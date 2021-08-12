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
        
        // Todo: Create ordered array of clip ranges to add to composition
        
        // Get the start and end timestamps of the clip
//        let creationDate = video.creationDate!.dateValue!
//        let startTimestamp = (match.history?[1] as! MatchState).generationEventTimestamp - creationDate.timeIntervalSince1970
//        let endTimestamp = (match.history?[2] as! MatchState).generationEventTimestamp - creationDate.timeIntervalSince1970
        
//        print(creationDate)
//        print(startTimestamp)
//        print(endTimestamp)
        
        // Debugging with hardcoded timestamps between 1 and 3 seconds
        let startTimestamp = 1
        let endTimestamp = 3
        
        // Milliseconds as the degree of accuracy for cuts
        let startTime = CMTimeMake(value: Int64(startTimestamp*10), timescale: 10)
        let endTime = CMTimeMake(value: Int64(endTimestamp*10), timescale: 10)
        let range = CMTimeRangeFromTimeToTime(start: startTime, end: endTime)
        
        // Create composition with one video and one audio track
        let composition = AVMutableComposition()
        let compositionVideoTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))
        let compositionAudioTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))

        // Get video and audio tracks from user's video
        let sourceVideoTrack = video.tracks(withMediaType: AVMediaType.video).first!
        let sourceAudioTrack = video.tracks(withMediaType: AVMediaType.audio).first!
        // Add specified range of user's video and audio track to the start of the composition's video and audio track
        // Todo: Add clips for ranges of each point
        do {
            try compositionVideoTrack!.insertTimeRange(range, of: sourceVideoTrack, at: CMTime.zero)
            try compositionAudioTrack!.insertTimeRange(range, of: sourceAudioTrack, at: CMTime.zero)
        } catch {
            print("Cannot add user video or audio track to the composition video or audio track")
            return
        }
        
        // Debug
//        print(composition.isExportable)
//        print(AVAssetExportSession.exportPresets(compatibleWith: composition))
        
        // Create exporter
        // Todo: Display progress to user
        let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetPassthrough)
        let outputPath = outputDirPath.appendingPathComponent("test.mov", isDirectory: false).path
        exporter?.outputURL = URL(fileURLWithPath: outputPath)
        exporter?.shouldOptimizeForNetworkUse = true
        exporter?.outputFileType = .mov
        // Export composition async
        exporter?.exportAsynchronously(completionHandler: {
             switch exporter!.status {
                case .failed:
                    print("Export failed: \(exporter!.error != nil ? exporter!.error!.localizedDescription : "No Error Info")")
                    // Todo: Tell user it failed and log
                case .cancelled:
                    print("Export canceled")
                case .completed:
                    print("Completed exporting")
                    // Todo: Save to Photo Library
                    // Todo: Delete temp file in Docs
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
        
        let decoder = JSONDecoder()
        // Once decoded add Match to CoreData
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = persistentContainer.viewContext
        
        do {
            let match = try decoder.decode(Match.self, from: matchJSON)
            NSLog("Match with id \(match.id!) decoded")
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
