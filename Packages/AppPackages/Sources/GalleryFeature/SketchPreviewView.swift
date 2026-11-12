//
//  SketchPreviewView.swift
//  lets-sketch
//
//  Created by Shafia Manzoor on 22/06/2026.
//

import SwiftUI
import Domain
import Data
import CustomViews
import Router

public struct SketchPreviewView: View {

    private let sketch: Sketch
    @State private var downloadClicked = false

    private var uiImageToShare: UIImage? {
        FileStorageService.shared.loadImage(fileName: sketch.previewFileName)
    }

    public init(sketch: Sketch) {
        self.sketch = sketch
    }

    public var body: some View {
        VStack(spacing: AppTheme.spacing) {
            previewImage
            HStack(spacing: 10) {
                CustomButton(title: AppStrings.download, icon: "arrow.down.to.line", style: .secondary, isFullWidth: true) {
                    downloadImage()
                }
                NavigationLink(value: AppRoute.drawing(sketchID: sketch.id)) {
                    CustomButtonLabel(title: AppStrings.edit, icon: "pencil", style:.primary)
                }
                CustomButton(title: AppStrings.share, icon: "square.and.arrow.up", style: .secondary, isFullWidth: true) {
                    if let uiImage = uiImageToShare {
                        actionShare(image: uiImage)
                    }
                }
            }
        }
        .padding(AppTheme.spacing)
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle(sketch.title)
        .navigationBarTitleDisplayMode(.inline)
        .alert(AppStrings.savedToPhotos, isPresented: $downloadClicked) {
            Button(AppStrings.confirm, role: .cancel) {}
        }
    }

    private var previewImage: some View {
        Group {
            if let image = FileStorageService.shared.loadImage(fileName: sketch.previewFileName) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Color.gray.opacity(0.2)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
        .overlay(RoundedRectangle(cornerRadius: AppTheme.cornerRadius).stroke(AppTheme.lavender, lineWidth: 1))
    }

    private func downloadImage() {
        guard let image = FileStorageService.shared.loadImage(fileName: sketch.previewFileName) else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        downloadClicked = true
    }

    private func actionShare(image: UIImage) {
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = scene.windows.first?.rootViewController {

            if let popoverController = activityVC.popoverPresentationController {
                popoverController.sourceView = rootVC.view
                popoverController.sourceRect = CGRect(x: rootVC.view.bounds.midX, y: rootVC.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }

            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }
}
