//
//  AppRoute.swift
//  SketchKit
//
//  Created by Shafia Manzoor on 30/06/2026.
//

import Foundation

public enum AppRoute: Hashable {
    case drawing(sketchID: UUID?)
    case gallery
    case preview(sketchID: UUID)
}
