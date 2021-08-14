//
//  ViewModel.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 23/07/2021.
//

import Foundation
import WatchConnectivity
import CoreData
import AVFoundation
import Photos

class ViewModel : NSObject, ObservableObject, WCSessionDelegate {
    
    // WatchConnectivity for recording match data on watchOS
    var session: WCSession?
    
    @Published var matches: [Match] = []
    
    // CoreData
    var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Model")
            container.loadPersistentStores { description, error in
                if let error = error {
                    fatalError("Unable to load persistent stores: \(error)")
                }
            }
            return container
        }()
    
    override init() {
        super.init()
        
        if WCSession.isSupported() {
            self.session = WCSession.default
            self.session!.delegate = self
            self.session!.activate()
        }
        
        fetchMatches()
    }
    
    func cut(video: AVAsset, match: Match) {
        // Create ordered array of clip ranges to add to composition
        let videoStartTimestamp = video.creationDate!.dateValue!.timeIntervalSince1970
        var clipTimeRanges = [CMTimeRange]()
        // Find each firstServe then end the clip at the point win or loss
        var i = 0
        while (i < match.history.count) {
            let currentState = match.history[i]
            // Find next state in history which is either a point win or loss
            if (currentState.generationEvent == .FirstServe) {
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
        print(clipTimeRanges.count)
        print(clipTimeRanges)
        
        // Debug so just use one hard coded time range
//        let oldClipTimeRanges = clipTimeRanges
//        clipTimeRanges = []
//        for i in 0..<20 {
//            clipTimeRanges.append(oldClipTimeRanges[i])
//        }
//        clipTimeRanges.append(CMTimeRange(start: CMTimeMake(value: 1, timescale: 1), end: CMTimeMake(value: 3, timescale: 1)))
        
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
        
        // Create composition with one video and one audio track
        let composition = AVMutableComposition()
        let compositionVideoTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))
        let compositionAudioTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))

        // Get video and audio tracks from user's video
        let sourceVideoTrack = video.tracks(withMediaType: AVMediaType.video).first!
        let sourceAudioTrack = video.tracks(withMediaType: AVMediaType.audio).first!
        
        // Add each clip using the time range of that clip and after the previous clip
        var endOfPreviousClip = CMTime.zero
        for clipTimeRange in clipTimeRanges {
            do {
                try compositionVideoTrack!.insertTimeRange(clipTimeRange, of: sourceVideoTrack, at: endOfPreviousClip)
                try compositionAudioTrack!.insertTimeRange(clipTimeRange, of: sourceAudioTrack, at: endOfPreviousClip)
                // Add the next clip after this one
                let value = clipTimeRange.duration.value + endOfPreviousClip.value
                endOfPreviousClip = CMTimeMake(value: value, timescale: 10)
            } catch {
                print("Cannot add clip at time in video from \(clipTimeRange.start.seconds)s to \(clipTimeRange.end.seconds)s. This clip will be left out of the composition.")
            }
        }
        
        // Debug
//        print(composition.isExportable)
//        print(AVAssetExportSession.exportPresets(compatibleWith: composition))
        
        
        // Export the composition to documents
        // Todo: Display progress to user
        let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetPassthrough)
        let outputPath = outputDirPath.appendingPathComponent("temp.mov", isDirectory: false).path
        let outputURL = URL(fileURLWithPath: outputPath)
        exporter?.outputURL = outputURL
        exporter?.outputFileType = .mov
        
        // Delete any existing temp file in Docs
        do {
            try FileManager.default.removeItem(at: outputURL)
        } catch {
            print("Could not delete temp file \(error.localizedDescription)")
        }
        
        // Poll exporter progress to update progress in UI
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            DispatchQueue.main.async {
                if (exporter?.status == .exporting) {
                    print(exporter?.progress ?? "no progress")
//                    self.exportProgress = exporter?.progress
//                    self.isExporting = true
                } else if (exporter?.status == .waiting) {
                    print("Exporter waiting...")
                } else {
//                    self.isExporting = false
                    timer.invalidate()
                }
            }
        }
        
        // Export composition async
        exporter?.exportAsynchronously(completionHandler: {
             switch exporter!.status {
                case .failed:
                    print("Export failed: \(exporter!.error != nil ? exporter!.error!.localizedDescription : "No Error Info")")
                    // Todo: Log error
//                    print(exporter!.error)
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
    
    func fetchMatches() {
        do {
            // Fetch all Match objects from CoreData
            let matches: [Match] = try persistentContainer.viewContext.fetch(Match.fetchRequest())
            // Update published matches var on main thread to alert views
            DispatchQueue.main.async {
                self.matches = matches
            }
        } catch {
            NSLog("Unable to fetch Match objects from CoreData")
        }
    }
    
    func deleteMatches(at indexSet: IndexSet) {
        indexSet.forEach { i in
            // Delete match from CoreData
            let match = matches[i]
            self.persistentContainer.viewContext.delete(match)
            // Save changes
            do {
                try self.persistentContainer.viewContext.save()
            } catch {
                NSLog("Unable to save changes to CoreData")
            }
        }
        fetchMatches()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        NSLog("didReceiveApplicationContext : \(applicationContext)")
        
        // Extract match from context
        let matchJSON = applicationContext["match"] as! Data
        print(matchJSON)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        // Once decoded add Match to CoreData
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = persistentContainer.viewContext
        
        do {
            let match = try decoder.decode(Match.self, from: matchJSON)
            NSLog("Match with id \(match.id) decoded")
        } catch{
            NSLog("Unable to decode match JSON")
        }
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            NSLog("Unable to save changes to CoreData")
        }
        
        fetchMatches()
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) { }
    
    func sessionDidDeactivate(_ session: WCSession) { }
    
}
