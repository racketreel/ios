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
    
//    @EnvironmentObject var videoEditor: VideoEditor
//    @State var video: AVAsset?
//    @State var showVideoPicker = false
    
    let match: TennisMatch
    @ObservedObject var viewModel: MatchViewModel
    
    init(match: TennisMatch) {
        // match is passed down from the parent view
        self.match = match
        self.viewModel = MatchViewModel(match: match)
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Custom background color.
            Color("Background")
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach (match.events, id: \.self) { event in
                        HStack {
                            Image(systemName: "exclamationmark.circle.fill")
                            Text(self.viewModel.display(event: event))
                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                .background(Color.white)
                                .cornerRadius(30)
                        }
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                }
                .padding()
            }
        }
//        .toolbar {
//            VStack {
//                Button("Process Video", action: {
//                    showVideoPicker = true
//                })
//                .disabled(videoEditor.progress != nil)
//            }
//        }
        .navigationTitle("Match")
        .navigationBarTitleDisplayMode(.inline)
//        .sheet(isPresented: $showVideoPicker, onDismiss: videoPickerDismiss) {
//            ImagePicker(video: $video)
//                .ignoresSafeArea()
//        }
    }
    
//    func videoPickerDismiss() {
//        if (video != nil) {
//            videoEditor.process(video: video!, match: match)
//        }
//    }
    
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView(match: TennisMatch.inProgress)
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
