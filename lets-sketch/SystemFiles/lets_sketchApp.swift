//
//  lets_sketchApp.swift
//  lets-sketch
//
//  Created by Shafia Manzoor on 18/06/2026.
//

import SwiftUI
import SwiftData
import Domain

@main
struct lets_sketchApp: App {
    var body: some Scene {
        WindowGroup {
            SplashContainerView()
        }
        .modelContainer(for: Sketch.self)
    }
}
