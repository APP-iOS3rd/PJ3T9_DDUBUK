import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var images: [UIImage]
    @Binding var editingIndex: Int?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = editingIndex == nil ? 10 - images.count : 1 // 수정 모드일 경우 선택 제한을 1로 설정
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            
            for result in results {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            if let editingIndex = self.parent.editingIndex {
                                // 수정 모드일 경우 특정 인덱스의 이미지를 교체
                                if self.parent.images.indices.contains(editingIndex) {
                                    self.parent.images[editingIndex] = image
                                }
                            } else {
                                // 새 이미지 추가 모드
                                self.parent.images.append(image)
                            }
                        }
                    }
                }
            }
        }
    }
}
