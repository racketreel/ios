//
//  MatchView.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 31/07/2021.
//

import SwiftUI
import AVFoundation
import PhotosUI

struct MatchView: View {
    
    @ObservedObject var model: ViewModel
    let match: Match
    
    @State private var showImagePicker = false
    @State private var video: AVAsset?
    
    var body: some View {
        List {
            ForEach (match.history, id: \.self) { matchState in
                HStack {
                    ScoreBoardView(state: matchState)
                    VStack(alignment: .leading) {
                        Text(matchState.generationEvent.description)
                            .font(.system(size: 16))
                        Text(String(matchState.generationEventTimestamp)) // todo format date
                        Text(matchState.pointType == .None ? "" : matchState.pointType.rawValue)
                        Text(matchState.breakPoint ? "Break Point" : "")
                        Spacer() // todo use frame
                    }
                    .font(.system(size: 12))
                }
            }
        }
        .toolbar {
            Button("Process Video", action: {
                self.showImagePicker = true
            })
        }
        .navigationTitle(match.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showImagePicker, onDismiss: cut) {
            ImagePicker(video: self.$video)
                .ignoresSafeArea()
        }
    }
    
    func cut() {
        if (video != nil) {
            model.cut(video: video!, match: match)
        } else {
            print("No video.")
        }
    }
    
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView(model: ViewModel(), match: Match())
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    
//    @Binding var isPresented: Bool
    @Binding var video: AVAsset?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> PHPickerViewController {
        // Request photo library access
        PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { authStatus in
           print(authStatus)
        })
        // Create and return photo picker
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = PHPickerFilter.any(of: [.videos])
        configuration.selectionLimit = 1
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
        
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            let identifiers = results.compactMap(\.assetIdentifier)
            let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
            
            PHImageManager.default().requestAVAsset(forVideo: fetchResult.firstObject!, options: PHVideoRequestOptions()) { avAsset, _, _ in
                self.parent.video = avAsset
            }
//            self.parent.isPresented.toggle()
        }
        
    }
    
}
