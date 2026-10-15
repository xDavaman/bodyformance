import Combine
import PhotosUI
import SwiftUI
import UIKit

// Fotos für alle Rezepte der Essenspläne an einer Stelle hochladen: einzeln (Kamera oder Mediathek) oder viele auf
// einmal auswählen und der Reihe nach zuordnen. Fortschritt zeigt, wie viele Rezepte schon ein Foto haben.

struct RecipePhotosView: View {
    @EnvironmentObject var store: RecipeStore
    @State private var filter = PhotoFilter.missing
    @State private var search = ""
    @State private var libraryTarget: Recipe?
    @State private var showLibrary = false
    @State private var libraryItem: PhotosPickerItem?
    @State private var cameraTarget: Recipe?
    @State private var batchItems: [PhotosPickerItem] = []
    @State private var queue: [UIImage] = []
    @State private var loadingBatch = false
    @State private var zipURL: URL?
    @State private var zipMessage: String?

    enum PhotoFilter: String, CaseIterable, Identifiable {
        case missing = "Ohne Foto", done = "Mit Foto", all = "Alle"
        var id: String { rawValue }
    }

    private var withPhoto: Int {
        let _ = store.photoVersion
        return store.all.filter { store.hasPhoto($0) }.count
    }

    private var items: [Recipe] {
        let _ = store.photoVersion
        return store.all.filter { r in
            let has = store.hasPhoto(r)
            let f = filter == .all || (filter == .missing ? !has : has)
            return f && (search.isEmpty || r.name.localizedCaseInsensitiveContains(search))
        }
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(withPhoto) von \(store.all.count) Rezepten haben ein Foto").font(.headline)
                    ProgressView(value: Double(withPhoto), total: Double(max(store.all.count, 1)))
                }
                PhotosPicker(selection: $batchItems, maxSelectionCount: 50, matching: .images) {
                    Label("Viele Fotos auf einmal hochladen", systemImage: "photo.stack")
                }
                if loadingBatch { ProgressView("Fotos werden geladen …") }
            } footer: {
                Text("Bei mehreren Fotos fragt die App für jedes Bild, zu welchem Rezept es gehört. Fotos bleiben auf dem iPhone und erscheinen im Essensplan, in der Rezeptliste und beim Teilen.")
            }

            Section {
                Picker("Anzeigen", selection: $filter) {
                    ForEach(PhotoFilter.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                if items.isEmpty {
                    Text(filter == .missing ? "Alle Rezepte haben ein Foto. 🎉" : "Keine Rezepte gefunden.").foregroundStyle(.secondary)
                }
                ForEach(items) { r in
                    HStack(spacing: 12) {
                        RecipeCover(recipe: r, height: 56)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(r.name).lineLimit(2)
                            Text(r.slots.map(\.rawValue).joined(separator: ", ")).font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Menu {
                            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                Button { cameraTarget = r } label: { Label("Foto aufnehmen", systemImage: "camera") }
                            }
                            Button { libraryTarget = r; showLibrary = true } label: { Label("Aus Mediathek", systemImage: "photo") }
                            if store.hasOwnPhoto(r) {
                                Button(role: .destructive) { store.removePhoto(for: r) } label: { Label("Foto entfernen", systemImage: "trash") }
                            }
                        } label: {
                            Image(systemName: store.hasPhoto(r) ? "photo.badge.checkmark" : "photo.badge.plus")
                                .font(.title3)
                        }
                    }
                }
            } header: {
                Text("Rezepte")
            }

            Section {
                Button {
                    zipURL = store.exportPhotosZip()
                    zipMessage = zipURL == nil ? "Noch keine eigenen Fotos vorhanden." : nil
                } label: { Label("Alle Fotos als ZIP vorbereiten", systemImage: "archivebox") }
                if let zipURL {
                    ShareLink(item: zipURL) { Label("ZIP teilen", systemImage: "square.and.arrow.up") }
                }
                if let zipMessage { Text(zipMessage).font(.footnote).foregroundStyle(.secondary) }
            } header: {
                Text("Für alle Nutzer übernehmen")
            } footer: {
                Text("Die ZIP enthält jedes Foto als „recipe-<Rezept>.jpg“. Im Projekt nach FitScan/RecipePhotos/ entpacken, dann sind die Bilder fest in der App und jeder sieht sie.")
            }
        }
        .searchable(text: $search, prompt: "Rezept suchen")
        .navigationTitle("Fotos für Essenspläne")
        .photosPicker(isPresented: $showLibrary, selection: $libraryItem, matching: .images)
        .onChange(of: libraryItem) { _, item in
            guard let item, let target = libraryTarget else { return }
            Task {
                if let data = try? await item.loadTransferable(type: Data.self) { store.setPhoto(data, for: target) }
                libraryItem = nil
                libraryTarget = nil
            }
        }
        .fullScreenCover(item: $cameraTarget) { r in
            CameraPicker { img in store.setPhoto(img, for: r) }
                .ignoresSafeArea()
        }
        .onChange(of: batchItems) { _, picked in
            guard !picked.isEmpty else { return }
            loadingBatch = true
            Task {
                var imgs: [UIImage] = []
                for it in picked {
                    if let d = try? await it.loadTransferable(type: Data.self), let img = UIImage(data: d) { imgs.append(img) }
                }
                batchItems = []
                loadingBatch = false
                queue = imgs
            }
        }
        .sheet(isPresented: Binding(get: { !queue.isEmpty }, set: { if !$0 { queue = [] } })) {
            if let img = queue.first {
                AssignPhotoSheet(image: img, remaining: queue.count) { recipe in
                    if let recipe { store.setPhoto(img, for: recipe) }
                    queue.removeFirst()
                }
            }
        }
    }
}

/// Ein Foto einem Rezept zuordnen (beim Hochladen mehrerer Fotos)
struct AssignPhotoSheet: View {
    let image: UIImage
    let remaining: Int
    /// nil = Foto überspringen
    var onPick: (Recipe?) -> Void
    @EnvironmentObject var store: RecipeStore
    @State private var search = ""

    private var candidates: [Recipe] {
        let list = store.all.filter { search.isEmpty || $0.name.localizedCaseInsensitiveContains(search) }
        // Rezepte ohne Foto zuerst
        return list.filter { !store.hasPhoto($0) } + list.filter { store.hasPhoto($0) }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Image(uiImage: image).resizable().scaledToFill()
                        .frame(height: 220).frame(maxWidth: .infinity).clipped()
                        .listRowInsets(EdgeInsets())
                } footer: {
                    Text("Noch \(remaining) Foto\(remaining == 1 ? "" : "s"). Tippe auf das passende Rezept.")
                }
                Section("Rezept wählen") {
                    ForEach(candidates) { r in
                        Button { onPick(r) } label: {
                            HStack {
                                Text(r.name).foregroundStyle(.primary)
                                Spacer()
                                if store.hasPhoto(r) { Image(systemName: "photo").foregroundStyle(.secondary) }
                            }
                        }
                    }
                }
            }
            .searchable(text: $search, prompt: "Rezept suchen")
            .navigationTitle("Foto zuordnen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Überspringen") { onPick(nil) } }
            }
        }
    }
}
