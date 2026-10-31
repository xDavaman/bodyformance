import PhotosUI
import SwiftUI
import UIKit

// MARK: - Essensfotos pro Mahlzeit

/// Fotos vom Essen, abgelegt pro Tag und Mahlzeit im App-Ordner (MealPhotos/2026-10-31_lunch_<id>.jpg). Nur lokal.
enum MealPhotos {
    static var folder: URL? {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let f = dir.appendingPathComponent("MealPhotos", isDirectory: true)
        try? FileManager.default.createDirectory(at: f, withIntermediateDirectories: true)
        return f
    }

    private static func prefix(day: Date, slot: MealSlot) -> String {
        "\(FoodLog.key(day))_\(String(describing: slot))_"
    }

    static func urls(day: Date, slot: MealSlot) -> [URL] {
        guard let f = folder,
              let items = try? FileManager.default.contentsOfDirectory(at: f, includingPropertiesForKeys: nil) else { return [] }
        let p = prefix(day: day, slot: slot)
        return items.filter { $0.lastPathComponent.hasPrefix(p) }.sorted { $0.lastPathComponent < $1.lastPathComponent }
    }

    static func add(_ img: UIImage, day: Date, slot: MealSlot) {
        guard let f = folder, let data = RecipeStore.jpeg(img, maxSide: 1400) else { return }
        let name = prefix(day: day, slot: slot) + "\(Int(Date().timeIntervalSince1970))-\(UUID().uuidString.prefix(6)).jpg"
        try? data.write(to: f.appendingPathComponent(name), options: .atomic)
    }

    static func remove(_ url: URL) {
        try? FileManager.default.removeItem(at: url)
    }

    /// Anzahl Fotos in einem Zeitraum (für den Monatsbericht)
    static func count(from: Date, to: Date) -> Int {
        guard let f = folder,
              let items = try? FileManager.default.contentsOfDirectory(at: f, includingPropertiesForKeys: nil) else { return 0 }
        let lo = FoodLog.key(from), hi = FoodLog.key(to)
        return items.filter { u in
            let k = String(u.lastPathComponent.prefix(10))
            return k >= lo && k < hi
        }.count
    }
}

/// Reihe mit Fotos einer Mahlzeit: Kamera, Mediathek, Vorschau, Löschen
struct MealPhotoRow: View {
    let day: Date
    let slot: MealSlot

    @State private var urls: [URL] = []
    @State private var camera = false
    @State private var pick: PhotosPickerItem?
    @State private var shown: URL?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Menu {
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        Button { camera = true } label: { Label("Foto aufnehmen", systemImage: "camera") }
                    }
                    PhotosPicker(selection: $pick, matching: .images) { Label("Aus Mediathek", systemImage: "photo") }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "camera.fill")
                        Text("Foto").font(.caption2)
                    }
                    .frame(width: 58, height: 58)
                    .background(Color.secondary.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
                }
                ForEach(urls, id: \.self) { u in
                    if let img = RecipeStore.image(at: u) {
                        Button { shown = u } label: {
                            Image(uiImage: img).resizable().scaledToFill()
                                .frame(width: 58, height: 58)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .onAppear(perform: reload)
        .onChange(of: day) { _, _ in reload() }
        .onChange(of: pick) { _, item in
            guard let item else { return }
            Task {
                if let data = try? await item.loadTransferable(type: Data.self), let img = UIImage(data: data) {
                    MealPhotos.add(img, day: day, slot: slot)
                }
                pick = nil
                reload()
            }
        }
        .fullScreenCover(isPresented: $camera) {
            CameraPicker { img in
                MealPhotos.add(img, day: day, slot: slot)
                reload()
            }
            .ignoresSafeArea()
        }
        .sheet(item: Binding(get: { shown.map { PhotoRef(url: $0) } }, set: { shown = $0?.url })) { ref in
            NavigationStack {
                Group {
                    if let img = RecipeStore.image(at: ref.url) {
                        Image(uiImage: img).resizable().scaledToFit()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) { Button("Fertig") { shown = nil } }
                    ToolbarItem(placement: .destructiveAction) {
                        Button(role: .destructive) {
                            MealPhotos.remove(ref.url)
                            shown = nil
                            reload()
                        } label: { Label("Löschen", systemImage: "trash") }
                    }
                }
            }
        }
    }

    private func reload() { urls = MealPhotos.urls(day: day, slot: slot) }

    private struct PhotoRef: Identifiable {
        let url: URL
        var id: String { url.path }
    }
}

// MARK: - Rezepte aus dem Internet

/// Links zu Rezeptsammlungen mit der passenden Ernährungsform (öffnet den Browser, es werden keine Daten gesendet)
struct OnlineRecipeLinks: View {
    var body: some View {
        ForEach(OnlineRecipeLinks.sources, id: \.title) { s in
            if let url = URL(string: s.url) {
                Link(destination: url) {
                    Label(s.title, systemImage: s.icon)
                }
            }
        }
    }

    struct Source { let title: String; let url: String; let icon: String }

    static let sources: [Source] = [
        Source(title: "High Protein bei Chefkoch", url: "https://www.chefkoch.de/rs/s0/high+protein/Rezepte.html", icon: "bolt.fill"),
        Source(title: "Low Carb bei Chefkoch", url: "https://www.chefkoch.de/rs/s0/low+carb/Rezepte.html", icon: "leaf.fill"),
        Source(title: "Low Carb und High Protein bei Chefkoch", url: "https://www.chefkoch.de/rs/s0/low+carb+high+protein/Rezepte.html", icon: "fork.knife"),
        Source(title: "Im Web suchen: eiweißreiche Rezepte", url: "https://www.google.com/search?q=high+protein+low+carb+rezepte", icon: "magnifyingglass")
    ]
}
