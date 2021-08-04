//
//  MatchView.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 31/07/2021.
//

import SwiftUI

struct MatchView: View {
    
    let match: Match
    
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        List {
            ForEach ((match.history!.array as! [MatchState]), id: \.self) { matchState in
                HStack {
                    ScoreBoardView(state: matchState)
                    VStack(alignment: .leading) {
                        Text(matchState.generationEventType!)
                            .font(.system(size: 16))
                        Text(String(matchState.generationEventTimestamp))
                        if (matchState.pointType != "none") {
                            Text(matchState.pointType! + (matchState.breakPoint ? " and break" : ""))
                        }
                        Spacer()
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
        .navigationTitle(String((match.history!.array[0] as! MatchState).generationEventTimestamp))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showImagePicker, onDismiss: cut) {
            ImagePicker(image: self.$inputImage)
                .ignoresSafeArea()
        }
    }
    
    // Temp - move to new ViewModel
    func cut() {
        print("Cutting")
    }
    
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView(match: Match())
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
        
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.mediaTypes = ["public.movie"]
        picker.allowsEditing = false
        // Longest ever tennis match 11 hours and 5 minutes (39900 seconds)
        picker.videoMaximumDuration = 39900
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}
