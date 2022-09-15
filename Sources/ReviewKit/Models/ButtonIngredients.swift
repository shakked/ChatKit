//
//  File 2.swift
//  
//
//  Created by Zachary Shakked on 9/15/22.
//

import UIKit

public struct ButtonIngredients {
    public let title: String
    public let image: UIImage?
    public let tapped: ((UIViewController) -> ())
    
    public init(title: String, image: UIImage?, tapped: @escaping ((UIViewController) -> ())) {
        self.title = title
        self.image = image
        self.tapped = tapped
    }
}
