import UIKit
import Combine
import PencilKit
import SwiftData
import Domain
import Data
import CustomViews

public final class CanvasViewModel: ObservableObject {
    @Published public var title: String
    @Published public private(set) var canUndo = false
    @Published public private(set) var canRedo = false

    private var canvasReference: PKCanvasView?
    private var existingSketch: Sketch?

    public init(existingSketch: Sketch? = nil) {
        self.existingSketch = existingSketch
        self.title = existingSketch?.title ?? AppStrings.untitledSketch
    }

    @MainActor
    func attach(canvas: PKCanvasView) {
        canvasReference = canvas
        if let data = existingSketch?.drawingData, let drawing = try? PKDrawing(data: data) {
            canvas.drawing = drawing
        }
        handleDrawingChange()
    }

    @MainActor
    public func handleDrawingChange() {
        canUndo = canvasReference?.undoManager?.canUndo ?? false
        canRedo = canvasReference?.undoManager?.canRedo ?? false
    }

    @MainActor
    public func undo() {
        canvasReference?.undoManager?.undo()
        handleDrawingChange()
    }

    @MainActor
    public func redo() {
        canvasReference?.undoManager?.redo()
        handleDrawingChange()
    }

    @MainActor
    public func save(context: ModelContext) -> Bool {
        guard let canvas = canvasReference else { return false }

        let drawing = canvas.drawing
        let bounds = canvas.bounds.isEmpty ? CGRect(x: 0, y: 0, width: 1024, height: 1024) : canvas.bounds
        let image = drawing.image(from: bounds, scale: 2)
        let fileName = existingSketch?.previewFileName ?? UUID().uuidString

        guard let savedFileName = FileStorageService.shared.savePNG(image, fileName: fileName) else {
            return false
        }

        if let sketch = existingSketch {
            sketch.title = title
            sketch.drawingData = drawing.dataRepresentation()
            sketch.previewFileName = savedFileName
            sketch.dateModified = Date()
        } else {
            let newSketch = Sketch(withTitle: title, data: drawing.dataRepresentation(), fileName: savedFileName)
            context.insert(newSketch)
            existingSketch = newSketch
        }

        try? context.save()
        return true
    }

    @MainActor
    public func activateCanvas() {
        canvasReference?.becomeFirstResponder()
    }

    @MainActor
    public func resetCanvas() {
        canvasReference?.drawing = PKDrawing()
        handleDrawingChange()
    }
}
