//
//  MenuItem.swift
//  DiscoveryFabButton
//
//  Created by Daniele De Matteo on 18/10/18.
//  Copyright © 2018 Schüco. All rights reserved.
//
import UIKit
public class MenuItem : UIButton {
    var id: String = ""
    public var label: String = "" {
        didSet {
            setTitle(label, for: .normal)
        }
    }
    var isActive: Bool = false
    
    fileprivate static let NOT_ACTIVE_ALPHA:CGFloat = 0.7
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    convenience public init(label:String) {
        self.init()
//        self.titleLabel?.text = label
        self.label = label
        self.id = UUID().uuidString
        initButton()
    }
    
    convenience public init(id:String, label:String) {
        self.init()
        self.label = label
        self.id = id
        
        initButton()
    }
//
//    public override func draw(_ rect: CGRect) {
//        alpha = isActive ? 1 : MenuItem.NOT_ACTIVE_ALPHA
//        super.draw(rect)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initButton() {
        setTitle(label, for: .normal)
        hideRight()
        
        if(isActive == false) {
            alpha = MenuItem.NOT_ACTIVE_ALPHA
        }
        titleLabel?.textAlignment = .right
        sizeToFit()
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    func setColor(_ color:UIColor) {
        setTitleColor(color, for: .normal)
        setNeedsDisplay()
    }
    
    func activate() {
        isActive = true
        alpha = 1
        setNeedsDisplay()
    }
    
    func deactivate() {
        isActive = false
        alpha = MenuItem.NOT_ACTIVE_ALPHA
        setNeedsDisplay()
    }
}

extension MenuItem {
    func hideRight() {
        alpha = 0
        transform = CGAffineTransform(translationX: 50, y: 0)
    }
    
    func comeIn() {
        alpha = isActive ? 1 : MenuItem.NOT_ACTIVE_ALPHA
        transform = CGAffineTransform.identity
    }
}
