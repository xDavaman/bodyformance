import Combine
import SwiftUI
import PhotosUI
import UIKit

/// Eigenes Profilbild (Kamera oder Mediathek), lokal als JPEG gespeichert.
final class AvatarStore: ObservableObject {
    @Published var image: UIImage?

    private var url: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("profile.jpg")
    }

    init() { image = UIImage(contentsOfFile: url.path) }

    func set(_ img: UIImage) {
        let r = Self.squared(img, side: 512)
        image = r
        try? r.jpegData(compressionQuality: 0.85)?.write(to: url, options: .atomic)
    }

    func remove() {
        image = nil
        try? FileManager.default.removeItem(at: url)
    }

    /// Mittiger quadratischer Ausschnitt, orientierungskorrigiert.
    static func squared(_ img: UIImage, side: CGFloat) -> UIImage {
        let size = img.size
        let scale = max(side / size.width, side / size.height)
        let w = size.width * scale, h = size.height * scale
        let fmt = UIGraphicsImageRendererFormat()
        fmt.scale = 1
        return UIGraphicsImageRenderer(size: CGSize(width: side, height: side), format: fmt).image { _ in
            img.draw(in: CGRect(x: (side - w) / 2, y: (side - h) / 2, width: w, height: h))
        }
    }
}

struct AvatarView: View {
    @EnvironmentObject var avatar: AvatarStore
    var size: CGFloat = 96
    var body: some View {
        Group {
            if let img = avatar.image {
                Image(uiImage: img).resizable().scaledToFill()
            } else {
                Image(systemName: "person.crop.circle.fill").resizable().foregroundStyle(.secondary)
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.secondary.opacity(0.3), lineWidth: 1))
    }
}

struct AvatarEditor: View {
    @EnvironmentObject var avatar: AvatarStore
    @AppStorage("profileName") private var name = ""
    @State private var showOptions = false
    @State private var showCamera = false
    @State private var showLibrary = false
    @State private var pickerItem: PhotosPickerItem?

    private var cameraAvailable: Bool { UIImagePickerController.isSourceTypeAvailable(.camera) }

    var body: some View {
        HStack(spacing: 16) {
            Button { showOptions = true } label: {
                ZStack(alignment: .bottomTrailing) {
                    AvatarView(size: 84)
                    Image(systemName: "camera.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.white, Color.accentColor)
                }
            }
            .buttonStyle(.plain)
            VStack(alignment: .leading, spacing: 4) {
                TextField("Dein Name", text: $name).font(.title3.bold())
                Text("Tippe auf das Bild, um ein Foto aufzunehmen oder aus der Mediathek zu wählen.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
        .confirmationDialog("Profilbild", isPresented: $showOptions) {
            if cameraAvailable { Button("Foto aufnehmen") { showCamera = true } }
            Button("Aus Mediathek wählen") { showLibrary = true }
            if avatar.image != nil { Button("Bild entfernen", role: .destructive) { avatar.remove() } }
            Button("Abbrechen", role: .cancel) {}
        }
        .photosPicker(isPresented: $showLibrary, selection: $pickerItem, matching: .images)
        .onChange(of: pickerItem) { _, item in
            guard let item else { return }
            Task {
                if let data = try? await item.loadTransferable(type: Data.self), let img = UIImage(data: data) {
                    await MainActor.run { avatar.set(img) }
                }
                await MainActor.run { pickerItem = nil }
            }
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraPicker { avatar.set($0) }.ignoresSafeArea()
        }
    }
}
