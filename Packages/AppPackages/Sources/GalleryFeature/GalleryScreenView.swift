//
//  GalleryScreenView.swift
//  lets-sketch
//
//  Created by Shafia Manzoor on 22/06/2026.
//

import SwiftUI
import SwiftData
import Domain
import CustomViews
import Router

public struct GalleryScreenView: View {

    @Query(sort: \Sketch.dateModified, order: .reverse) private var sketches: [Sketch]

    public let columns = [GridItem(.adaptive(minimum: 150, maximum: 260), spacing: 14)]
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            if sketches.isEmpty {
                ContentUnavailableView {
                    Label(AppStrings.noSketches, systemImage: "paintpalette")
                } description: {
                    Text(AppStrings.noSketchesDescription)
                }.padding(.top, 120)
            } else {
                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(sketches) { sketch in
                        NavigationLink(value: AppRoute.preview(sketchID: sketch.id)) {
                            SketchGridCell(sketch: sketch)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(AppTheme.spacing)
            }
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle(AppStrings.mySketches)
    }
}
