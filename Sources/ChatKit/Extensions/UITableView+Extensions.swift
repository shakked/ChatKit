//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/12/22.
//

import UIKit

public protocol ReusableView: NSObjectProtocol {
    static var reuseIdentifier: String { get }
}

public extension ReusableView where Self: UIView {
    
    // Note this default will work unless:
    // 1. The cell is a subclass of another ReusableView
    // 2. The nib name is different from the class name
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

public extension UITableView {
    
    // MARK: Layout

    func prepareForSelfSizing(estimatedItemHeight e: CGFloat = 80) {
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = e
    }
    
    // MARK: Dequeue
    
    func dequeueCell<T: ReusableView>(for indexPath: IndexPath) -> T {
        return dequeueCell(withIdentifier: T.reuseIdentifier, for: indexPath)
    }
    
    func dequeueCell<T>(withIdentifier identifier: String, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else { fatalError("Type not registered with identifier: \(identifier)") }
        return cell
    }
    
    func dequeueHeaderFooter<T: ReusableView>() -> T {
        return dequeueHeaderFooter(withIdentifier: T.reuseIdentifier)
    }
    
    func dequeueHeaderFooter<T>(withIdentifier identifier: String) -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T else { fatalError("Type not registered with identifier: \(identifier)") }
        return view
    }
    
    // MARK: Registration
    
    func registerCell(type: ReusableView.Type) {
        if let nib = UINib(potentialName: String(describing: type)) {
            register(nib, forCellReuseIdentifier: type.reuseIdentifier)
            return
        }
        
        register(type.self, forCellReuseIdentifier: type.reuseIdentifier)
    }
    
    func registerCells(types: ReusableView.Type...) {
        types.forEach { registerCell(type: $0) }
    }
    
    func registerHeaderFooterView(type: ReusableView.Type) {
        if let nib = UINib(potentialName: String(describing: type)) {
            register(nib, forHeaderFooterViewReuseIdentifier: type.reuseIdentifier)
            return
        }
        
        register(type.self, forHeaderFooterViewReuseIdentifier: type.reuseIdentifier)
    }
}

extension UINib {
    convenience init?(potentialName name: String, bundle: Bundle = Bundle.main) {
        guard UINib.exists(nibName: name, bundle: bundle) else { return nil }
        self.init(nibName: name, bundle: bundle)
    }
    
    static func exists(nibName name: String, bundle: Bundle = Bundle.main) -> Bool {
        return bundle.path(forResource: name, ofType:"nib") != nil
    }
}

