//
//  RootView.swift
//  lets-sketch
//
//  Created by Shafia Manzoor on 19/06/2026.
//

import SwiftUI
import Domain
import CustomViews
import GalleryFeature
import Router
import Canvas
import SwiftData

struct RootView: View {
    @AppStorage("selectedAppearance") private var selectedAppearance = "system"

    var body: some View {
        TabView {
            SketchTabView(isDarkMode: isDarkModeBinding)
                .tabItem { Label(AppStrings.sketchTab, systemImage: "pencil.and.scribble") }

            TraceTabView(isDarkMode: isDarkModeBinding)
                .tabItem { Label(AppStrings.traceTab, systemImage: "point.3.connected.trianglepath.dotted") }

            GalleryTabView(isDarkMode: isDarkModeBinding)
                .tabItem { Label(AppStrings.galleryTab, systemImage: "square.grid.2x2") }
        }
        .tint(AppTheme.purple)
        .preferredColorScheme(preferredColorScheme)
    }

    private var isDarkModeBinding: Binding<Bool> {
        Binding(
            get: { selectedAppearance == "dark" },
            set: { selectedAppearance = $0 ? "dark" : "light" }
        )
    }

    private var preferredColorScheme: ColorScheme? {
        switch selectedAppearance {
        case "dark": .dark
        case "light": .light
        default: nil
        }
    }
}

private struct SketchTabView: View {
    @Binding var isDarkMode: Bool
    @State private var path: [AppRoute] = []
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack(path: $path) {
            DrawingScreenView(viewModel: CanvasViewModel())
                .toolbar { appearanceToolbar }
                .navigationDestination(for: AppRoute.self, destination: destination(for:))
        }
    }

    @ToolbarContentBuilder
    private var appearanceToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            AppearanceToggle(isDarkMode: $isDarkMode)
        }
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .gallery:
            GalleryScreenView()
        case .preview(let sketchID):
            if let sketch = fetchSketch(id: sketchID) {
                SketchPreviewView(sketch: sketch)
            }
        case .drawing(let sketchID):
            if let id = sketchID, let sketch = fetchSketch(id: id) {
                DrawingScreenView(viewModel: CanvasViewModel(existingSketch: sketch), isEditingExisting: true)
            } else {
                DrawingScreenView(viewModel: CanvasViewModel())
            }
        }
    }

    private func fetchSketch(id: UUID) -> Sketch? {
        let descriptor = FetchDescriptor<Sketch>(predicate: #Predicate { $0.id == id })
        return try? modelContext.fetch(descriptor).first
    }
}

private struct TraceTabView: View {
    @Binding var isDarkMode: Bool

    var body: some View {
        NavigationStack {
            TraceScreenView()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        AppearanceToggle(isDarkMode: $isDarkMode)
                    }
                }
        }
    }
}

private struct GalleryTabView: View {
    @Binding var isDarkMode: Bool

    var body: some View {
        NavigationStack {
            GalleryScreenView()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        AppearanceToggle(isDarkMode: $isDarkMode)
                    }
                }
        }
    }
}
