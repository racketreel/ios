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
    
    @ObservedObject var viewModel: MatchViewModel
    
    init (match: Match) {
        let matches = PersistenceController.getTestMatches()
        print(matches?[0] ?? [Match()])
        viewModel = MatchViewModel(match: match)
    }
    
    var body: some View {
        List {
            Button("Export Match", action: {
                _ = viewModel.exportMatch()
            })
            ForEach (viewModel.match.history, id: \.self) { state in
                MatchStateView(state: state)
            }
        }
        .toolbar {
            Button("Process Video", action: {
                viewModel.showVideoPicker = true
            })
        }
        .navigationTitle(viewModel.match.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.showVideoPicker, onDismiss: viewModel.trimMatchVideo) {
            ImagePicker(video: $viewModel.video)
                .ignoresSafeArea()
        }
    }
    
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView(match: Match.example)
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
