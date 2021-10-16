//
//  VideoEditor.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 31/08/2021.
//

import Foundation
import AVFoundation
import PhotosUI

class VideoEditor: ObservableObject {
    
    @Published var progress: Float?
    @Published var success: Bool = false
    @Published var error: Bool = false
    
    func process(video: AVAsset, match: Match) {
        // Only process one video at a time
        if (progress != nil) {
            return
        }
        
        self.success = false
        self.error = false
        
        // Create output directory
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(string: documentsDirectory)!
        let outputDirPath = docURL.appendingPathComponent("Tennis")
        if !FileManager.default.fileExists(atPath: outputDirPath.path) {
            do {
                try FileManager.default.createDirectory(atPath: outputDirPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        // Delete any existing temp file in Docs
        let outputPath = outputDirPath.appendingPathComponent("temp.mp4", isDirectory: false).path
        let outputURL = URL(fileURLWithPath: outputPath)
        do {
            try FileManager.default.removeItem(at: outputURL)
        } catch {
            print("Could not delete temp file \(error.localizedDescription)")
        }
        
        // Start showing progress in UI
        DispatchQueue.main.async {
            self.progress = 0
        }
        
        let clipTimes = getClipTimes(match: match, videoStartTimestamp: video.creationDate!.dateValue!.timeIntervalSince1970)
        
        // Get video and audio tracks from user's match video
        let sourceVideoTrack = video.tracks(withMediaType: AVMediaType.video).first!
        let sourceAudioTrack = video.tracks(withMediaType: AVMediaType.audio).first
        
        // Create composition with one video and one audio track
        let composition = AVMutableComposition()
        let compositionVideoTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))!
        let compositionAudioTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))!
        
        // Add clips for each point to the composition
        var endOfPreviousClip = CMTime.zero
        var compositionTimes = [(CMTimeRange, MatchState)]()
        for clipTime in clipTimes {
            let clipTimeRange = clipTime.0
            do {
                try compositionVideoTrack.insertTimeRange(clipTimeRange, of: sourceVideoTrack, at: endOfPreviousClip)
                if (sourceAudioTrack != nil) {
                    try compositionAudioTrack.insertTimeRange(clipTimeRange, of: sourceAudioTrack!, at: endOfPreviousClip)
                }
                // Add the next clip after this one
                let value = clipTimeRange.duration.value + endOfPreviousClip.value
                let endOfThisClip = CMTimeMake(value: value, timescale: 10)
                compositionTimes.append((CMTimeRange(start: endOfPreviousClip, end: endOfThisClip), clipTime.1))
                endOfPreviousClip = endOfThisClip
            } catch {
                print("Cannot add clip at time in video from \(clipTimeRange.start.seconds)s to \(clipTimeRange.end.seconds)s. This clip will be left out of the composition.")
            }
        }
        
        let videoInfo = orientation(from: sourceVideoTrack.preferredTransform)
        let videoSize: CGSize
        if videoInfo.isPortrait {
          videoSize = CGSize(
            width: sourceVideoTrack.naturalSize.height,
            height: sourceVideoTrack.naturalSize.width)
        } else {
          videoSize = sourceVideoTrack.naturalSize
        }
        
        let videoLayer = CALayer()
        videoLayer.frame = CGRect(origin: .zero, size: videoSize)
        
        // Use text as watermark for now
        let watermarkLayer = CATextLayer()
        watermarkLayer.string = "Processed by Racket Reel"
        watermarkLayer.fontSize = 80
        watermarkLayer.shouldRasterize = true
        watermarkLayer.rasterizationScale = UIScreen.main.scale
        watermarkLayer.foregroundColor = UIColor.white.cgColor
        watermarkLayer.backgroundColor = UIColor.clear.cgColor
        watermarkLayer.alignmentMode = .center
        watermarkLayer.frame = CGRect(origin: .zero, size: videoSize)
        
        // Place watermarkLayer on top of videoLayer
        let outputLayer = CALayer()
        outputLayer.frame = CGRect(origin: .zero, size: videoSize)
        outputLayer.addSublayer(videoLayer)
        outputLayer.addSublayer(watermarkLayer)
        
        // Add scoreboard layers
        for compositionTime in compositionTimes {
            outputLayer.addSublayer(scoreboardLayerNew(matchState: compositionTime.1, timeRange: compositionTime.0, videoSize: videoSize))
        }
        
        // Create videoComposition to layer the video and watermark for an AVComposition
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = videoSize
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
        
        // Add resulting videoComposition into layer tree
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(
          postProcessingAsVideoLayer: videoLayer,
          in: outputLayer)
        
        // Intruct videoComposition on layering
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(
          start: .zero,
          duration: composition.duration)
        videoComposition.instructions = [instruction]
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTrack)
        layerInstruction.setTransform(sourceVideoTrack.preferredTransform, at: .zero) // Match source orientation
        instruction.layerInstructions = [layerInstruction]
        
        // Export the composition to documents
        let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        exporter?.videoComposition = videoComposition
        exporter?.outputURL = outputURL
        exporter?.outputFileType = AVFileType.mp4
        exporter?.videoComposition = videoComposition
        
        // Poll exporter progress to update progress
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            DispatchQueue.main.async {
                if (exporter?.status == .exporting) {
                    self.progress = exporter?.progress
                } else if (exporter?.status == .waiting) {
                    print("Exporter waiting")
                } else {
                    // Final progress and message in exporter completionHandler
                    timer.invalidate()
                }
            }
        }
        
        // Export composition
        exporter?.exportAsynchronously(completionHandler: {
             switch exporter!.status {
                case .failed:
                    print("Export failed: \(exporter!.error != nil ? exporter!.error!.localizedDescription : "No Error Info")")
                    print(exporter!.error!)
                    DispatchQueue.main.async {
                        self.progress = nil
                        self.error = true
                    }
                case .cancelled:
                    print("Export canceled")
                    DispatchQueue.main.async {
                        self.progress = nil
                    }
                case .completed:
                    print("Completed exporting")
                    DispatchQueue.main.async {
                        self.progress = nil
                    }
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: outputPath))
                    }) { success, error in
                        if success {
                            print("Video has been saved to photo library.")
                            DispatchQueue.main.async {
                                self.success = true
                            }
                        }
                        if (error != nil) {
                            print("Something went wrong saving to photo library: \(error!.localizedDescription)")
                            print(error!)
                            DispatchQueue.main.async {
                                self.error = true
                            }
                        }
                    }
                default:
                    self.progress = nil
                    self.error = true
                }
        })
    }
    
    private func orientation(from transform: CGAffineTransform) -> (orientation: UIImage.Orientation, isPortrait: Bool) {
      var assetOrientation = UIImage.Orientation.up
      var isPortrait = false
      if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
        assetOrientation = .right
        isPortrait = true
      } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
        assetOrientation = .left
        isPortrait = true
      } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
        assetOrientation = .up
      } else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
        assetOrientation = .down
      }
      return (assetOrientation, isPortrait)
    }
    
    private func getClipTimes(match: Match, videoStartTimestamp: Double) -> [(CMTimeRange, MatchState)] {
        var clipTimes = [(CMTimeRange, MatchState)]()
        // Find each firstServe then end the clip at the point win or loss
        var i = 0
        while (i < match.history.count) {
            let currentState = match.history[i]
            if (currentState.generationEvent == .FirstServe) {
                // Find next state in history which is either a point win or loss
                var j = i
                while (j < match.history.count) {
                    let otherState = match.history[j]
                    if (otherState.generationEvent == .Win || otherState.generationEvent == .Loss) {
                        // Get video timestamps for start and end of the clip
                        let startTimestamp = currentState.generationEventTimestamp - videoStartTimestamp
                        let endTimestamp = otherState.generationEventTimestamp - videoStartTimestamp
                        // Create and add time range
                        let startTime = CMTimeMake(value: Int64(startTimestamp*10), timescale: 10)
                        let endTime = CMTimeMake(value: Int64(endTimestamp*10), timescale: 10)
                        let timeRange = CMTimeRangeFromTimeToTime(start: startTime, end: endTime)
                        clipTimes.append((timeRange, currentState))
                        break
                    }
                    j += 1
                }
            }
            i += 1
        }
        return clipTimes
    }
    
    private func scoreboardLayer(matchState: MatchState, timeRange: CMTimeRange, videoSize: CGSize) -> CALayer {
        let firstLine = "ME \(matchState.setsUser) \(matchState.gamesUser) \(matchState.pointsUser)"
        let secondLine = "OP \(matchState.setsOpponent) \(matchState.gamesOpponent) \(matchState.pointsOpponent)"
        
        let textLayer = CATextLayer()
        textLayer.opacity = 0.0
        textLayer.frame = CGRect(x: 10, y: videoSize.height - 210, width: 800, height: 200)
        textLayer.string = "\(firstLine)\n\(secondLine)"
        textLayer.fontSize = 60
        textLayer.shouldRasterize = true
        textLayer.rasterizationScale = UIScreen.main.scale
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor

        let startVisible = CABasicAnimation.init(keyPath:"opacity")
        startVisible.duration = 0    // no fade
        startVisible.repeatCount = 1
        startVisible.fromValue = 0.0
        startVisible.toValue = 0.8
        startVisible.beginTime = timeRange.start.seconds // overlay time range start duration
        startVisible.isRemovedOnCompletion = false
        startVisible.fillMode = CAMediaTimingFillMode.forwards
        textLayer.add(startVisible, forKey: "startAnimation")

        let endVisible = CABasicAnimation.init(keyPath:"opacity")
        endVisible.duration = 0
        endVisible.repeatCount = 1
        endVisible.fromValue = 0.8
        endVisible.toValue = 0.0
        endVisible.beginTime = timeRange.end.seconds
        endVisible.fillMode = CAMediaTimingFillMode.forwards
        endVisible.isRemovedOnCompletion = false
        textLayer.add(endVisible, forKey: "endAnimation")
        
        return textLayer
    }
    
    private func scoreboardLayerNew(matchState: MatchState, timeRange: CMTimeRange, videoSize: CGSize) -> CALayer {
        let backgroundY = videoSize.height - 275
        let playerOneY = videoSize.height - 150
        let playerOneServeY = playerOneY + 25
        let playerTwoY = videoSize.height - 250
        let playerTwoServeY = playerTwoY + 25
        
        let backgroundX = CGFloat(50)
        let nameX = CGFloat(100)
        let serveX = CGFloat(425)
        let setX = CGFloat(475)
        let gameX = CGFloat(550)
        let pointX = CGFloat(625)
        
        let backgroundSize = CGSize(width: 725, height: 225)
        let nameSize = CGSize(width: 300, height: 75)
        let serveSize = CGSize(width: 25, height: 25)
        let setGameSize = CGSize(width: 50, height: 75)
        let pointSize = CGSize(width: 75, height: 75)
        
        let backgroundOrigin = CGPoint(x: backgroundX, y: backgroundY)
        let playerOneNameOrigin = CGPoint(x: nameX, y: playerOneY)
        let playerOneServeOrigin = CGPoint(x: serveX, y: playerOneServeY)
        let playerOneSetsOrigin = CGPoint(x: setX, y: playerOneY)
        let playerOneGamesOrigin = CGPoint(x: gameX, y: playerOneY)
        let playerOnePointsOrigin = CGPoint(x: pointX, y: playerOneY)
        let playerTwoNameOrigin = CGPoint(x: nameX, y: playerTwoY)
        let playerTwoServeOrigin = CGPoint(x: serveX, y: playerTwoServeY)
        let playerTwoSetsOrigin = CGPoint(x: setX, y: playerTwoY)
        let playerTwoGamesOrigin = CGPoint(x: gameX, y: playerTwoY)
        let playerTwoPointsOrigin = CGPoint(x: pointX, y: playerTwoY)
        
        // Scoreboard background
        let backgroundLayer = CALayer()
        backgroundLayer.frame = CGRect(origin: backgroundOrigin, size: backgroundSize)
        backgroundLayer.backgroundColor = UIColor.black.cgColor
        backgroundLayer.cornerRadius = 30
        
        // Player 1
        // Name
        let playerOneNameLayer = CATextLayer()
        playerOneNameLayer.string = "Player 1"
        playerOneNameLayer.frame = CGRect(origin: playerOneNameOrigin, size: nameSize)
        applyScoreboardTextStyling(textLayer: playerOneNameLayer)
        // Serve
        let playerOneServeLayer = CALayer()
        playerOneServeLayer.frame = CGRect(origin: playerOneServeOrigin, size: serveSize)
        playerOneServeLayer.cornerRadius = 12.5
        playerOneServeLayer.backgroundColor = UIColor.white.cgColor
        playerOneServeLayer.opacity = matchState.toServe ? 1.0 : 0.0
        // Sets
        let playerOneSetsLayer = CATextLayer()
        playerOneSetsLayer.string = String(matchState.setsUser)
        playerOneSetsLayer.frame = CGRect(origin: playerOneSetsOrigin, size: setGameSize)
        applyScoreboardTextStyling(textLayer: playerOneSetsLayer)
        // Games
        let playerOneGamesLayer = CATextLayer()
        playerOneGamesLayer.string = String(matchState.gamesUser)
        playerOneGamesLayer.frame = CGRect(origin: playerOneGamesOrigin, size: setGameSize)
        applyScoreboardTextStyling(textLayer: playerOneGamesLayer)
        // Points
        let playerOnePointsLayer = CATextLayer()
        playerOnePointsLayer.string = matchState.pointsUser
        playerOnePointsLayer.frame = CGRect(origin: playerOnePointsOrigin, size: pointSize)
        applyScoreboardTextStyling(textLayer: playerOnePointsLayer)
        
        // Player 2
        // Name
        let playerTwoNameLayer = CATextLayer()
        playerTwoNameLayer.string = "Player 2"
        playerTwoNameLayer.frame = CGRect(origin: playerTwoNameOrigin, size: nameSize)
        applyScoreboardTextStyling(textLayer: playerTwoNameLayer)
        // Serve
        let playerTwoServeLayer = CALayer()
        playerTwoServeLayer.frame = CGRect(origin: playerTwoServeOrigin, size: serveSize)
        playerTwoServeLayer.cornerRadius = 12.5
        playerTwoServeLayer.backgroundColor = UIColor.white.cgColor
        playerTwoServeLayer.opacity = matchState.toServe ? 0.0 : 1.0
        // Sets
        let playerTwoSetsLayer = CATextLayer()
        playerTwoSetsLayer.string = String(matchState.setsOpponent)
        playerTwoSetsLayer.frame = CGRect(origin: playerTwoSetsOrigin, size: setGameSize)
        applyScoreboardTextStyling(textLayer: playerTwoSetsLayer)
        // Games
        let playerTwoGamesLayer = CATextLayer()
        playerTwoGamesLayer.string = String(matchState.gamesOpponent)
        playerTwoGamesLayer.frame = CGRect(origin: playerTwoGamesOrigin, size: setGameSize)
        applyScoreboardTextStyling(textLayer: playerTwoGamesLayer)
        // Points
        let playerTwoPointsLayer = CATextLayer()
        playerTwoPointsLayer.string = matchState.pointsOpponent
        playerTwoPointsLayer.frame = CGRect(origin: playerTwoPointsOrigin, size: pointSize)
        applyScoreboardTextStyling(textLayer: playerTwoPointsLayer)
        
        // Assemble all layers into parentLayer
        let parentLayer = CALayer()
        parentLayer.addSublayer(backgroundLayer)
        parentLayer.addSublayer(playerOneNameLayer)
        parentLayer.addSublayer(playerOneServeLayer)
        parentLayer.addSublayer(playerOneSetsLayer)
        parentLayer.addSublayer(playerOneGamesLayer)
        parentLayer.addSublayer(playerOnePointsLayer)
        parentLayer.addSublayer(playerTwoNameLayer)
        parentLayer.addSublayer(playerTwoServeLayer)
        parentLayer.addSublayer(playerTwoSetsLayer)
        parentLayer.addSublayer(playerTwoGamesLayer)
        parentLayer.addSublayer(playerTwoPointsLayer)
        
        // Scoreboard initially hidden unless it is the first one
        if (timeRange.start.seconds != 0.0) {
            parentLayer.opacity = 0.0
        }
        
        // Add animation to only show this scoreboard during the point in the composition
        // Show
        let startVisible = CABasicAnimation.init(keyPath:"opacity")
        startVisible.duration = 0.01 // no fade, cannot be zero
        startVisible.repeatCount = 1
        startVisible.fromValue = 0.0
        startVisible.toValue = 0.8
        startVisible.beginTime = timeRange.start.seconds
        startVisible.isRemovedOnCompletion = false
        startVisible.fillMode = CAMediaTimingFillMode.forwards
        parentLayer.add(startVisible, forKey: "startAnimation")
        // Hide
        let endVisible = CABasicAnimation.init(keyPath:"opacity")
        endVisible.duration = 0.01
        endVisible.repeatCount = 1
        endVisible.fromValue = 0.8
        endVisible.toValue = 0.0
        endVisible.beginTime = timeRange.end.seconds
        endVisible.fillMode = CAMediaTimingFillMode.forwards
        endVisible.isRemovedOnCompletion = false
        parentLayer.add(endVisible, forKey: "endAnimation")
        
        return parentLayer
    }
    
    private func applyScoreboardTextStyling(textLayer: CATextLayer) {
        textLayer.fontSize = 60
        textLayer.shouldRasterize = true
        textLayer.rasterizationScale = UIScreen.main.scale
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
    }
    
}
