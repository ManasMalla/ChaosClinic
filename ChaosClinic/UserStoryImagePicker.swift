import SwiftUI
import PhotosUI

/// A view for picking or taking the user's story image.
struct UserStoryImagePicker: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("user-story-image") private var userStoryImageData: Data?
    @State private var cameraPresented = false
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var pickedImage: UIImage?
    
    var onComplete: (() -> Void)? = nil

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                if let img = pickedImage {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 220, maxHeight: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding()
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [8]))
                            .foregroundColor(.secondary)
                            .frame(width: 180, height: 180)
                        Image(systemName: "camera")
                            .font(.system(size: 44))
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack(spacing: 16) {
                    Button {
                        cameraPresented = true
                    } label: {
                        Label("Take Photo", systemImage: "camera")
                    }
                    .buttonStyle(.borderedProminent)

                    PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                        Label("Choose from Gallery", systemImage: "photo.on.rectangle")
                    }
                    .buttonStyle(.bordered)
                }
                
                Spacer()
                
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                    Spacer()
                    Button("Save") {
                        if let img = pickedImage, let data = img.jpegData(compressionQuality: 0.85) {
                            userStoryImageData = data
                            onComplete?()
                            dismiss()
                        }
                    }
                    .disabled(pickedImage == nil)
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Add Your Story")
            .sheet(isPresented: $cameraPresented) {
                CameraPicker(image: $pickedImage, isPresented: $cameraPresented)
            }
            .onChange(of: selectedPhoto) { item in
                if let item {
                    Task {
                        if let data = try? await item.loadTransferable(type: Data.self), let uiImg = UIImage(data: data) {
                            pickedImage = uiImg
                        }
                    }
                }
            }
        }
    }
}

/// UIKit camera picker wrapper
struct CameraPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isPresented: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraPicker
        init(_ parent: CameraPicker) { self.parent = parent }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let img = info[.originalImage] as? UIImage {
                parent.image = img
            }
            parent.isPresented = false
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}
