//
//  Sketch.swift
//  lets-sketch
//
//  Created by Shafia Manzoor on 19/06/2026.
//


//import Foundation
//import SwiftData
//
//@Model
//public final class Sketch {
//
//    public var id: UUID
//    public var title: String
//    public var dateCreated: Date
//    public var dateModified: Date
//    public var drawingData: Data       /// raw PKDrawing Paths
//    public var previewFileName: String /// file name
//
//    init(title: String, drawingData: Data, previewFileName: String) {
//        self.id = UUID()
//        self.title = title
//        self.dateCreated = Date()
//        self.dateModified = Date()
//        self.drawingData = drawingData
//        self.previewFileName = previewFileName
//    }
//}

import Foundation
import SwiftData

@Model
public final class Sketch {
    public var id: UUID
    public var title: String
    public var dateCreated: Date
    public var dateModified: Date
    public var drawingData: Data
    public var previewFileName: String

    public init(withTitle title: String, data: Data, fileName: String) {
        self.id = UUID()
        self.title = title
        self.dateCreated = Date()
        self.dateModified = Date()
        self.drawingData = data
        self.previewFileName = fileName
    }
}

