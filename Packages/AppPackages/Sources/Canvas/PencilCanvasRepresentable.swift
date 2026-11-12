import SwiftUI
import PencilKit
import UIKit

public struct PencilCanvasRepresentable: UIViewRepresentable {
    private let viewModel: CanvasViewModel
    private let referenceImage: UIImage?
    private let canvasOpacity: CGFloat

    public init(
        viewModel: CanvasViewModel,
        referenceImage: UIImage? = nil,
        canvasOpacity: CGFloat = 1
    ) {
        self.viewModel = viewModel
        self.referenceImage = referenceImage
        self.canvasOpacity = canvasOpacity
    }

    public func makeUIView(context: Context) -> SketchCanvasView {
        let view = SketchCanvasView()
        view.canvas.delegate = context.coordinator
        view.configure(referenceImage: referenceImage, canvasOpacity: canvasOpacity)
        viewModel.attach(canvas: view.canvas)
        return view
    }

    public func updateUIView(_ uiView: SketchCanvasView, context: Context) {
        uiView.configure(referenceImage: referenceImage, canvasOpacity: canvasOpacity)
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    public final class Coordinator: NSObject, PKCanvasViewDelegate {
        private let viewModel: CanvasViewModel

        init(viewModel: CanvasViewModel) {
            self.viewModel = viewModel
        }

        public func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            viewModel.handleDrawingChange()
        }
    }
}
