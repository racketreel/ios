//
//  MatchView.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 31/07/2021.
//

import SwiftUI
import AVFoundation
import PhotosUI

struct MatchView: View {
    
    @EnvironmentObject var videoEditor: VideoEditor
    @State var match: Match
    @State var video: AVAsset?
    @State var showVideoPicker: Bool
    
    init (match: Match) {
        self.match = match
        self.showVideoPicker = false
    }
    
    var body: some View {
        List {
            ForEach (match.history, id: \.self) { state in
                MatchStateView(state: state)
            }
        }
        .toolbar {
            VStack {
                Button("Process Video", action: {
                    showVideoPicker = true
                })
                .disabled(videoEditor.progress != nil)
            }
        }
        .navigationTitle(match.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showVideoPicker, onDismiss: videoPickerDismiss) {
            ImagePicker(video: $video)
                .ignoresSafeArea()
        }
    }
    
    func videoPickerDismiss() {
        if (video != nil) {
            videoEditor.process(video: video!, match: match)
        }
    }
    
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView(match: Match.example)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    
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
            if let video = fetchResult.firstObject {
                PHImageManager.default().requestAVAsset(forVideo: video, options: PHVideoRequestOptions()) { videoAsset, _, _ in
                    DispatchQueue.main.async {
                        self.parent.video = videoAsset
                    }
                }
            }
        }
        
    }
    
}
