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
        for clipTime in clipTimes {
            do {
                try compositionVideoTrack.insertTimeRange(clipTime, of: sourceVideoTrack, at: endOfPreviousClip)
                if (sourceAudioTrack != nil) {
                    try compositionAudioTrack.insertTimeRange(clipTime, of: sourceAudioTrack!, at: endOfPreviousClip)
                }
                // Add the next clip after this one
                let value = clipTime.duration.value + endOfPreviousClip.value
                endOfPreviousClip = CMTimeMake(value: value, timescale: 10)
            } catch {
                print("Cannot add clip at time in video from \(clipTime.start.seconds)s to \(clipTime.end.seconds)s. This clip will be left out of the composition.")
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
        
        let videoComposition = createVideoComposition(videoSize: videoSize)
        
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
    
    private func getClipTimes(match: Match, videoStartTimestamp: Double) -> [CMTimeRange] {
        var clipTimes = [CMTimeRange]()
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
                        clipTimes.append(timeRange)
                        break
                    }
                    j += 1
                }
            }
            i += 1
        }
        return clipTimes
    }
    
    private func createVideoComposition(videoSize: CGSize) -> AVMutableVideoComposition {
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
        
        // Create videoComposition to layer the video and watermark for an AVComposition
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = videoSize
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
        
        // Add resulting videoComposition into layer tree
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(
          postProcessingAsVideoLayer: videoLayer,
          in: outputLayer)
        
        return videoComposition
    }
    
}
