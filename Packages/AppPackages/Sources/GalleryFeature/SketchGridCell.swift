//
//  SketchGridCell.swift
//  lets-sketch
//
//  Created by Shafia Manzoor on 22/06/2026.
//

import SwiftUI
import Domain
import Data
import CustomViews

public struct SketchGridCell: View {

    private let sketch: Sketch

    init(sketch: Sketch) {
        self.sketch = sketch
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            previewImage
            Text(sketch.title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(AppTheme.textPrimary)
                .lineLimit(1)
        }
    }

    private var previewImage: some View {
        Group {
            if let image = FileStorageService.shared.loadImage(fileName: sketch.previewFileName) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                placeholder
            }
        }
        .frame(height: 150)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
        .overlay(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius).stroke(AppTheme.lavender, lineWidth: 1))
    }

    private var placeholder: some View {
        RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius)
            .fill(AppTheme.babyPink.opacity(0.3))
            .overlay(Image(systemName: "photo").foregroundColor(AppTheme.purple))
    }
}
