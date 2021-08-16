//
//  MatchViewModel.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 16/08/2021.
//

import Foundation
import AVFoundation
import PhotosUI

class MatchViewModel: ObservableObject {
    
    @Published var match: Match
    @Published var video: AVAsset?
    
    @Published var exportProgress: Float?
    @Published var showVideoPicker = false
    
    init (match: Match) {
        self.match = match
    }
    
    private func getTrimmedTimeRanges() -> [CMTimeRange] {
        var clipTimeRanges = [CMTimeRange]()
        
        // Create ordered array of clip ranges
        let videoStartTimestamp = video!.creationDate!.dateValue!.timeIntervalSince1970
        
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
                        clipTimeRanges.append(timeRange)
                        break
                    }
                    j += 1
                }
            }
            i += 1
        }
        
        // Debug
//        print(clipTimeRanges.count)
//        print(clipTimeRanges)
        
        return clipTimeRanges
    }
    
    private func newComposition(timeRanges: [CMTimeRange]) -> AVComposition {
        // Create composition with one video and one audio track
        let composition = AVMutableComposition()
        let compositionVideoTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))
        let compositionAudioTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))

        // Get video and audio tracks from user's video
        let sourceVideoTrack = video!.tracks(withMediaType: AVMediaType.video).first!
        let sourceAudioTrack = video!.tracks(withMediaType: AVMediaType.audio).first!
        
        // Add each clip using the time range of that clip and after the previous clip
        var endOfPreviousClip = CMTime.zero
        for timeRange in timeRanges {
            do {
                try compositionVideoTrack!.insertTimeRange(timeRange, of: sourceVideoTrack, at: endOfPreviousClip)
                try compositionAudioTrack!.insertTimeRange(timeRange, of: sourceAudioTrack, at: endOfPreviousClip)
                // Add the next clip after this one
                let value = timeRange.duration.value + endOfPreviousClip.value
                endOfPreviousClip = CMTimeMake(value: value, timescale: 10)
            } catch {
                print("Cannot add clip at time in video from \(timeRange.start.seconds)s to \(timeRange.end.seconds)s. This clip will be left out of the composition.")
            }
        }
        
        return composition
    }
    
    func trimMatchVideo() {
        if (video == nil) {
            print("No video selected.")
            return
        }
        
        let clipTimeRanges = getTrimmedTimeRanges()
                
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
        let outputPath = outputDirPath.appendingPathComponent("temp.mov", isDirectory: false).path
        let outputURL = URL(fileURLWithPath: outputPath)
        do {
            try FileManager.default.removeItem(at: outputURL)
        } catch {
            print("Could not delete temp file \(error.localizedDescription)")
        }
        
        // Debug
//        print(composition.isExportable)
//        print(AVAssetExportSession.exportPresets(compatibleWith: composition))
        
        let composition = newComposition(timeRanges: clipTimeRanges)
        
        // Export the composition to documents
        // Todo: Display progress to user
        let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetPassthrough)
        exporter?.outputURL = outputURL
        exporter?.outputFileType = .mov
        
        // Poll exporter progress to update progress
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            DispatchQueue.main.async {
                if (exporter?.status == .exporting) {
                    print(exporter?.progress ?? "no progress")
                    self.exportProgress = exporter?.progress
                } else if (exporter?.status == .waiting) {
                    print("Exporter waiting...")
                    self.exportProgress = nil
                } else {
                    self.exportProgress = nil
                    timer.invalidate()
                }
            }
        }
        
        // Export composition async
        exporter?.exportAsynchronously(completionHandler: {
             switch exporter!.status {
                case .failed:
                    print("Export failed: \(exporter!.error != nil ? exporter!.error!.localizedDescription : "No Error Info")")
                    print(exporter!.error!)
                case .cancelled:
                    print("Export canceled")
                case .completed:
                    print("Completed exporting")
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: outputPath))
                    }) { success, error in
                        if success {
                            print("Video has been saved to photo library.")
                        }
                        if (error != nil) {
                            print("Something went wrong saving to photo library: \(error!.localizedDescription)")
                            print(error!)
                        }
                    }
                default:
                    break
                }
        })
    }
    
}
