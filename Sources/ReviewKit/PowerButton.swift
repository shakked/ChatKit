import UIKit
import GitMart

public class PowerButton: UIButton {

    public let gitMartProjectID: String = "6318a6aa90eb1af078a0cda7"
    
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable public var borderColor: UIColor? = nil {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }

    @IBInspectable public var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable public var shadowColor: UIColor? {
        didSet {
            layer.shadowColor = shadowColor?.cgColor
        }
    }

    @IBInspectable public var shadowOffset: CGSize = .zero {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }

    @IBInspectable public var shadowRadius: CGFloat = 0.0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }

    @IBInspectable public var shadowOpacity: Float = 0.0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    private var activityIndicator: UIActivityIndicatorView?
    private var temporaryTitle: String?
    private var temporaryImage: UIImage?
    var greedyTouches = true
    private var isLoading: Bool = false
    private var didTriggerStopLoading = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override public var tintColor: UIColor! {
        didSet {
            titleLabel?.textColor = tintColor
            activityIndicator?.color = tintColor
        }
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        addTarget(self, action: #selector(touchDragExit), for: .touchDragExit)
        addTarget(self, action: #selector(touchDragExit), for: .touchCancel)
    }
    
    @objc private func touchDragExit() {
        let duration = 0.4
        let scale: CGFloat = 1
        
        UIView.animate(withDuration: duration) {
            self.titleLabel?.alpha = 1.0
            self.imageView?.alpha = 1.0
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    @objc private func touchDown() {
        let duration = 0.2
        let damping: CGFloat = 1
        let scale: CGFloat = 0.925
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
        
        self.titleLabel?.alpha = 0.32
        self.imageView?.alpha = 0.32
        
        if #available(iOS 13.0, *) {
            UIImpactFeedbackGenerator(style: .light).impactOccurred(intensity: 0.6)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc private func touchUpInside() {
        let duration = 0.4
        let damping: CGFloat = 0.3
        let scale: CGFloat = 1
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.titleLabel?.alpha = 1.0
            self.imageView?.alpha = 1.0
        }, completion: nil)
        
        if #available(iOS 13.0, *) {
            UIImpactFeedbackGenerator(style: .light).impactOccurred(intensity: 0.9)
        } else {
            // Fallback on earlier versions
        }
    }
    
    public func startLoading() {
        didTriggerStopLoading = false
        isLoading = true
        isEnabled = false
        temporaryTitle = titleLabel?.text
        temporaryImage = imageView?.image
        UIView.animate(withDuration: 0.1) {
            self.titleLabel?.alpha = 0.0
            self.imageView?.alpha = 0.0
        } completion: { _ in
            if !self.didTriggerStopLoading {
                self.setTitle(nil, for: .normal)
                self.setImage(nil, for: .normal)
            }
        }
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            activityIndicator.style = .medium
        } else {
            // Fallback on earlier versions
        }
        activityIndicator.color = tintColor
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.activityIndicator = activityIndicator
    }
    
    public func stopLoading() {
        didTriggerStopLoading = true
        isEnabled = true
        if let temporaryTitle = temporaryTitle {
            setTitle(temporaryTitle, for: .normal)
        }
        if let temporaryImage = temporaryImage {
            setImage(temporaryImage, for: .normal)
        }
        UIView.animate(withDuration: 0.15) {
            self.titleLabel?.alpha = 1.0
            self.imageView?.alpha = 1.0
        }
        self.activityIndicator?.stopAnimating()
        self.activityIndicator?.removeFromSuperview()
        self.activityIndicator = nil
        isLoading = false
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.isHidden || !self.isUserInteractionEnabled || self.alpha < 0.01 { return nil }
        let inset: CGFloat = greedyTouches ? -15 : -10
        let largerFrame = self.bounds.insetBy(dx: inset, dy: inset)
        return (largerFrame.contains(point)) ? self : nil
    }
}
