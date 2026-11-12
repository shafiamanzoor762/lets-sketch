import SwiftUI
import SwiftData
import PhotosUI
import UIKit
import CustomViews

public struct TraceScreenView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = CanvasViewModel()
    @State private var selectedItem: PhotosPickerItem?
    @State private var referenceImage: UIImage?
    @State private var canvasOpacity = 0.65
    @State private var didSave = false

    public init() {}

    public var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: AppTheme.spacing) {
                    TraceHeaderView()
                    TraceCanvasSection(
                        viewModel: viewModel,
                        referenceImage: referenceImage,
                        canvasOpacity: canvasOpacity,
                        availableHeight: proxy.size.height
                    )
                    TraceControlsView(
                        selectedItem: $selectedItem,
                        hasReferenceImage: referenceImage != nil,
                        canvasOpacity: $canvasOpacity,
                        saveAction: { didSave = viewModel.save(context: modelContext) }
                    )
                }
                .frame(maxWidth: 800)
                .padding(.horizontal, AppTheme.spacing)
                .padding(.vertical, AppTheme.spacing)
                .frame(maxWidth: .infinity)
            }
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle(AppStrings.traceTab)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: selectedItem) { _, item in
            loadReferenceImage(from: item)
        }
        .alert(AppStrings.sketchSaved, isPresented: $didSave) {
            Button(AppStrings.confirm, role: .cancel) {}
        }
    }

    private func loadReferenceImage(from item: PhotosPickerItem?) {
        guard let item else { return }
        Task {
            guard let data = try? await item.loadTransferable(type: Data.self),
                  let image = UIImage(data: data) else { return }
            referenceImage = image
        }
    }
}

private struct TraceHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(AppStrings.traceTitle)
                .font(.title2.bold())
                .foregroundStyle(AppTheme.textPrimary)
            Text(AppStrings.traceSubtitle)
                .font(.subheadline)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct TraceCanvasSection: View {
    @ObservedObject var viewModel: CanvasViewModel
    let referenceImage: UIImage?
    let canvasOpacity: Double
    let availableHeight: CGFloat

    var body: some View {
        Group {
            if let referenceImage {
                PencilCanvasRepresentable(
                    viewModel: viewModel,
                    referenceImage: referenceImage,
                    canvasOpacity: canvasOpacity
                )
            } else {
                ContentUnavailableView(
                    AppStrings.tracePlaceholder,
                    systemImage: "photo.on.rectangle.angled",
                    description: Text(AppStrings.traceSubtitle)
                )
            }
        }
        .frame(height: min(max(availableHeight * 0.52, 320), 620))
        .frame(maxWidth: .infinity)
        .background(AppTheme.canvasSurface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .stroke(AppTheme.lavender.opacity(0.7), lineWidth: 1)
        }
    }
}

private struct TraceControlsView: View {
    @Binding var selectedItem: PhotosPickerItem?
    let hasReferenceImage: Bool
    @Binding var canvasOpacity: Double
    let saveAction: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            HStack(spacing: 12) {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label(
                        hasReferenceImage ? AppStrings.replacePhoto : AppStrings.choosePhoto,
                        systemImage: "photo.badge.plus"
                    )
                }
                .buttonStyle(TraceActionButtonStyle(isPrimary: false))

                Button(action: saveAction) {
                    Label(AppStrings.traceSave, systemImage: "checkmark")
                }
                .disabled(!hasReferenceImage)
                .buttonStyle(TraceActionButtonStyle(isPrimary: true))
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Label(AppStrings.canvasOpacity, systemImage: "circle.lefthalf.filled")
                    Spacer()
                    Text(canvasOpacity, format: .percent.precision(.fractionLength(0)))
                        .monospacedDigit()
                }
                .font(.subheadline.weight(.medium))
                .foregroundStyle(AppTheme.textPrimary)

                Slider(value: $canvasOpacity, in: 0.15...1)
                    .tint(AppTheme.purple)
            }
            .padding(AppTheme.spacing)
            .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
        }
    }
}

private struct TraceActionButtonStyle: ButtonStyle {
    let isPrimary: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(isPrimary ? Color.white : AppTheme.deepPurple)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius)
                    .fill(isPrimary ? AnyShapeStyle(AppTheme.gradient) : AnyShapeStyle(AppTheme.surface))
            }
            .overlay {
                RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius)
                    .stroke(isPrimary ? .clear : AppTheme.lavender, lineWidth: 1)
            }
            .opacity(configuration.isPressed ? 0.75 : 1)
    }
}
