//
//  DiscoveryFabButtonView.swift
//  DiscoveryFabButton
//
//  Created by Daniele De Matteo on 16/10/18.
//  Copyright © 2018 Kuama. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - DiscoveryFabButton Protocol
public protocol DiscoveryFabButtonViewProtocol {
    func onOpen()
    func onClose()
    func onMenuItemSelected(menuItem: MenuItem, index: Int)
    func onMenuItemUnselected(menuItem: MenuItem, index: Int)
}

extension DiscoveryFabButtonViewProtocol {
    func onOpen() {}
    
    func onClose() {}
    
    func onMenuItemUnselected(menuImte: MenuItem, index: Int){}
}


public class DiscoveryFabButtonView : UIView {
    
    private static let SIZE: CGFloat = 60
    private static let MARGIN: CGFloat = 20
    private static let DISCOVERY_ANIMATION_DURATION = 5.0
    private static let OPEN_CLOSE_ANIMATION_DURATION = 0.28
    
    // MARK: - Status flags - maybe turn them to struct
    private var didSetupConstraints = false
    private var isOpened = false
    private var isAnimating = false
    
    public var delegate:DiscoveryFabButtonViewProtocol?
    
    private static let windowBounds = UIScreen.main.bounds
    
    private let overlay:UIView = UIView(frame: DiscoveryFabButtonView.frameInSize( DiscoveryFabButtonView.SIZE))
    
    private let discovery:UIView = UIView(frame: DiscoveryFabButtonView.frameInSize( DiscoveryFabButtonView.SIZE))
    public var discoveryColor = #colorLiteral(red: 0.4901960784, green: 0.4784313725, blue: 0.737254902, alpha: 1) {
        didSet {
            discovery.backgroundColor = discoveryColor
            setNeedsDisplay()
        }
    }
    
    private let button:UIButton = UIButton(frame: DiscoveryFabButtonView.frameInSize(DiscoveryFabButtonView.SIZE))
    
    public var buttonColor:UIColor = #colorLiteral(red: 0.3921568627, green: 0.3411764706, blue: 0.6509803922, alpha: 1) {
        didSet {
            button.backgroundColor = buttonColor
            setNeedsDisplay()
        }
    }
    
    public var buttonIcon:UIImage! {
        didSet {
            button.setImage(buttonIcon, for: UIControl.State.normal)
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    private var buttonIconClose:UIImage!
    
    public var menuItems = [MenuItem]() {
        didSet {
            refreshMenuItems()
            setNeedsDisplay()
        }
    }
    private let menuItemsView = UIStackView(frame: DiscoveryFabButtonView.frameInSize(DiscoveryFabButtonView.SIZE))
    
    public var menuItemsSpacing:CGFloat = 10 {
        didSet {
            menuItemsView.spacing = menuItemsSpacing
            setNeedsDisplay()
        }
    }
    
    public var menuItemsColor: UIColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1) {
        didSet {
            menuItemsView.subviews.forEach{ view in
                if let button = view as? UIButton {
                    button.setTitleColor(menuItemsColor, for: .normal)
                }
            }
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: DiscoveryFabButtonView.frameInSize( DiscoveryFabButtonView.SIZE))
        setupUI()
    }
    
    convenience init() {
        self.init(frame: DiscoveryFabButtonView.frameInSize(DiscoveryFabButtonView.SIZE))
    }
    
    
    
    convenience init(buttonColor:UIColor) {
        self.init()
        self.buttonColor = buttonColor
    }
    
    convenience init(buttonColor:UIColor, buttonIcon:UIImage) {
        self.init()
        self.buttonColor = buttonColor
        self.buttonIcon = buttonIcon
    }
    
    convenience init(discoveryColor:UIColor) {
        self.init()
        self.discoveryColor = discoveryColor
    }
    
    convenience init(buttonColor:UIColor, buttonIcon:UIImage, discoveryColor:UIColor) {
        self.init()
        self.buttonColor = buttonColor
        self.buttonIcon = buttonIcon
        self.discoveryColor = discoveryColor
    }
    
    convenience init(buttonColor:UIColor, buttonIcon:UIImage, menu:[MenuItem]) {
        self.init()
        self.buttonColor = buttonColor
        self.buttonIcon = buttonIcon
        self.menuItems = menu
    }
    
    convenience init(buttonColor:UIColor, buttonIcon:UIImage, discoveryColor:UIColor, menu:[MenuItem]) {
        self.init()
        self.buttonColor = buttonColor
        self.buttonIcon = buttonIcon
        self.discoveryColor = discoveryColor
        self.menuItems = menu
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public API
public extension DiscoveryFabButtonView {
    
    func inTableView() {
        removeFromSuperview()
        let window = UIApplication.shared.keyWindow!
        window.addSubview(self)
    }
    
    func remove() {
        removeFromSuperview()
    }
    
    func toggle() {
        if (isOpened) {
            close()
        } else {
            open()
        }
    }
    
    func show() {
        open()
    }
    
    func dismiss() {
        close()
    }
}

// MARK: - UI Seteup
fileprivate extension DiscoveryFabButtonView {
    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        setNeedsUpdateConstraints()
        
        // overlay styles
        overlay.layer.cornerRadius = DiscoveryFabButtonView.SIZE / 2
        overlay.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1963827055)
        overlay.alpha = 0
        addSubview(overlay)
        
        discovery.layer.cornerRadius = DiscoveryFabButtonView.SIZE / 2
        discovery.alpha = 0
        discovery.backgroundColor = discoveryColor
        addSubview(discovery)
        
        // button styles
        button.backgroundColor = buttonColor
        button.tintColor = .white
        button.layer.cornerRadius = DiscoveryFabButtonView.SIZE / 2
        
        let podBundle = Bundle(for: DiscoveryFabButtonView.self)
        if let url = podBundle.url(forResource: "Icons", withExtension: "bundle"){   // leave the extension as "bundle"
            let mykitBundle = Bundle(url: url)
            
            self.buttonIcon = UIImage(named: "filter", in:mykitBundle, compatibleWith: nil)
            
            self.buttonIconClose = UIImage(named: "close", in:mykitBundle, compatibleWith: nil)
        }
        
        button.drawShadow()
        
        
        menuItemsView.axis = .vertical
        menuItemsView.distribution = .equalSpacing
        menuItemsView.alignment = .trailing
        menuItemsView.spacing = menuItemsSpacing
        menuItemsView.translatesAutoresizingMaskIntoConstraints = false
        menuItemsView.alpha = 0
        menuItemsView.isUserInteractionEnabled = false
        menuItemsView.backgroundColor = .red
        addSubview(menuItemsView)
        
        addSubview(button)
        
        listenTaps()
    }
}

// MARK: - Menu setup
fileprivate extension DiscoveryFabButtonView {
    func refreshMenuItems() {
        
        menuItemsView.subviews.forEach { $0.removeFromSuperview()}
        
        menuItems.enumerated().forEach { arg in
            let(index, item) = arg
            
            item.setColor(menuItemsColor)
            
            item.addTapGestureRecognizer {
                if(item.isActive) {
                    item.deactivate()
                    self.delegate?.onMenuItemUnselected(menuItem: item, index: index)
                } else {
                    self.menuItems.forEach{ item in
                        item.deactivate()
                    }
                    
                    item.activate()
                    
                    self.delegate?.onMenuItemSelected(menuItem: item, index: index)
                }
                
            }
            self.menuItemsView.addArrangedSubview(item)
            
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
}

// MARK: - Tap listeners
fileprivate extension DiscoveryFabButtonView {
    
    func listenTaps() {
        let onTapToggle = UITapGestureRecognizer(target: self, action: #selector(onButtonClicked))
        onTapToggle.numberOfTapsRequired = 1
        isUserInteractionEnabled = true
        button.addGestureRecognizer(onTapToggle)
        
        let onTapClose = UITapGestureRecognizer(target: self, action: #selector(onOverlayClicked))
        onTapClose.numberOfTapsRequired = 1
        overlay.addGestureRecognizer(onTapClose)
        overlay.isUserInteractionEnabled = true
    }
    
    @objc func onButtonClicked(_:UITapGestureRecognizer) {
        toggle()
    }
    
    @objc func onOverlayClicked(_:UITapGestureRecognizer) {
        if isOpened {
            close()
        }
    }
}

// MARK: - Open / close animation
fileprivate extension DiscoveryFabButtonView {
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    func open() {
        frame = CGRect(x: 0, y: 0, width: DiscoveryFabButtonView.windowBounds.width, height: DiscoveryFabButtonView.windowBounds.height)
        let rect = CGRect(x: DiscoveryFabButtonView.windowBounds.width - overlay.frame.width - DiscoveryFabButtonView.MARGIN, y: DiscoveryFabButtonView.windowBounds.height - overlay.frame.height - DiscoveryFabButtonView.MARGIN, width: overlay.frame.width, height: overlay.frame.height)
        overlay.frame = rect
        button.frame = rect
        discovery.frame = rect
        
        delay(0.2) {
            self.animateIn()
        }
    }
    
    func animateIn() {
        
        menuItemsView.frame = CGRect(
            x: DiscoveryFabButtonView.windowBounds.width - menuItemsView.frame.width - DiscoveryFabButtonView.MARGIN - (DiscoveryFabButtonView.SIZE / 3),
            y: DiscoveryFabButtonView.windowBounds.height - DiscoveryFabButtonView.SIZE - (DiscoveryFabButtonView.MARGIN * 2) - self.menuItemsView.frame.height,
            width: menuItemsView.frame.width,
            height: menuItemsView.frame.height
        )
        menuItemsView.alpha = 1
        menuItemsView.isUserInteractionEnabled = true
        
        let overlayScale = DiscoveryFabButtonView.getOverlaySize()
        let discoveryScale = overlayScale / DiscoveryFabButtonView.SIZE - (DiscoveryFabButtonView.MARGIN / DiscoveryFabButtonView.SIZE)
        
        UIView.animate(withDuration: DiscoveryFabButtonView.OPEN_CLOSE_ANIMATION_DURATION, animations: {
            self.overlay.alpha = 1
            self.overlay.transform = CGAffineTransform(scaleX: overlayScale, y: overlayScale)
            self.discovery.alpha = 1
            self.menuItemsView.subviews.reversed().enumerated().forEach { (arg) in
                let (index, view) = arg
                UIView.animate(
                    withDuration: DiscoveryFabButtonView.OPEN_CLOSE_ANIMATION_DURATION / Double((self.menuItemsView.subviews.count - 1)),
                    delay: 0.1 * Double(index),
                    options: .curveEaseOut,
                    animations: {
                        if let button = view as? MenuItem {
                            button.comeIn()
                        }
                })
            }
            self.discovery.transform = CGAffineTransform(scaleX: discoveryScale , y: discoveryScale)
        }) { _ in
            self.isAnimating = false
            self.isOpened = true
            self.button.setImage(self.buttonIconClose, for: .normal)
            
            self.delegate?.onOpen()
        }
    }
    
    func close() {
        isAnimating = true
        
        self.menuItemsView.subviews.enumerated().forEach { (arg) in
            let (index, view) = arg
            UIView.animate(
                withDuration: DiscoveryFabButtonView.OPEN_CLOSE_ANIMATION_DURATION / Double((self.menuItemsView.subviews.count - 1)),
                delay: 0.1 * Double(index),
                options: .curveEaseOut,
                animations: {
                    if let button = view as? MenuItem {
                        button.hideRight()
                    }
            })
        }
        let count = Double(self.menuItemsView.subviews.count)
        delay(0.1 * (count / 2)) {
            UIView.animate(withDuration: DiscoveryFabButtonView.OPEN_CLOSE_ANIMATION_DURATION, animations: {
                self.overlay.transform = CGAffineTransform.identity
                self.overlay.alpha = 0
                self.discovery.transform = CGAffineTransform.identity
                self.discovery.alpha = 0
            }) { _ in
                self.frame = DiscoveryFabButtonView.bottomRightWindowFramePadded()
                self.overlay.frame = DiscoveryFabButtonView.frameInSize(DiscoveryFabButtonView.SIZE)
                self.discovery.frame = DiscoveryFabButtonView.frameInSize(DiscoveryFabButtonView.SIZE)
                self.button.frame = DiscoveryFabButtonView.frameInSize(DiscoveryFabButtonView.SIZE)
                self.isAnimating = false
                self.isOpened = false
                self.button.setImage(self.buttonIcon, for: .normal)
                self.delegate?.onClose()
            }
        }
    }
}

// MARK: - Constraints
extension DiscoveryFabButtonView {
    override public func updateConstraints() {
        if didSetupConstraints == false {
            addConstraints()
        }
        
        super.updateConstraints()
    }
    
    private func addConstraints() {
        
        if let parent = superview {
            snp.makeConstraints { make in
                make.height.width.equalTo(DiscoveryFabButtonView.SIZE)
                make.bottom.right.equalTo(parent).offset(-DiscoveryFabButtonView.MARGIN)
            }
        }
        
        frame = DiscoveryFabButtonView.bottomRightWindowFrame()
    }
}

fileprivate extension DiscoveryFabButtonView {
    private static func frameInSize(_ size:CGFloat) -> CGRect {
        return makeRect(x: 0, y: 0, size: size)
    }
    
    private static func bottomRightWindowFrame() -> CGRect {
        return makeRect(x: windowBounds.width - DiscoveryFabButtonView.SIZE, y: windowBounds.height - DiscoveryFabButtonView.SIZE, size: DiscoveryFabButtonView.SIZE)
    }
    
    private static func bottomRightWindowFramePadded() -> CGRect {
        return makeRect(
            x: windowBounds.width - DiscoveryFabButtonView.SIZE - DiscoveryFabButtonView.MARGIN,
            y: windowBounds.height - DiscoveryFabButtonView.SIZE - DiscoveryFabButtonView.MARGIN,
            size: DiscoveryFabButtonView.SIZE)
    }
    
    private static func makeRect(x:CGFloat, y: CGFloat, size: CGFloat) -> CGRect{
        return CGRect(x: x, y: y, width: size, height: size)
    }
    
    private static func getOverlaySize() -> CGFloat {
        let window = UIScreen.main.bounds
        let size = window.width > window.height ? window.width : window.height
        return size * 1.5
    }
}

extension UIView {
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
}

public extension UIButton {
    func drawShadow() {
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 10.0
        layer.masksToBounds = false
    }
}
