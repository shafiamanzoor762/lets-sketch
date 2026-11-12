import UIKit
import PencilKit

/// UIKit host for a PencilKit canvas with an optional reference image beneath it.
public final class SketchCanvasView: UIView {
    private let referenceImageView = UIImageView()

    private(set) lazy var canvas: PKCanvasView = {
        let canvasView = PKCanvasView()
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        canvasView.tool = PKInkingTool(.pen, color: .systemPink, width: 6)
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        return canvasView
    }()

    private lazy var toolPicker = PKToolPicker()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }

    public override func didMoveToWindow() {
        super.didMoveToWindow()
        guard window != nil else { return }
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas)
        canvas.becomeFirstResponder()
    }

    func configure(referenceImage: UIImage?, canvasOpacity: CGFloat) {
        referenceImageView.image = referenceImage
        referenceImageView.isHidden = referenceImage == nil
        referenceImageView.alpha = canvasOpacity
//        canvas.alpha = canvasOpacity
    }

    private func setupLayout() {
        backgroundColor = .systemBackground
        referenceImageView.contentMode = .scaleAspectFit
        referenceImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(referenceImageView)
        addSubview(canvas)
        NSLayoutConstraint.activate([
            referenceImageView.topAnchor.constraint(equalTo: topAnchor),
            referenceImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            referenceImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            referenceImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            canvas.topAnchor.constraint(equalTo: topAnchor),
            canvas.bottomAnchor.constraint(equalTo: bottomAnchor),
            canvas.leadingAnchor.constraint(equalTo: leadingAnchor),
            canvas.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
