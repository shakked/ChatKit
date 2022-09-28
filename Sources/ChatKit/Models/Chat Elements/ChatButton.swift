//
//  File 2.swift
//  
//
//  Created by Zachary Shakked on 9/15/22.
//

import UIKit

public struct ChatButton: Chat {
    public let message: String = ""
    public let title: String
    public let image: UIImage?
    public let tapped: ((UIViewController) -> ())?
    
    public init(title: String, image: UIImage?, tapped: ((UIViewController) -> ())?) {
        self.title = title
        self.image = image
        self.tapped = tapped
    }
}
