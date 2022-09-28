//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/20/22.
//

import Foundation

public struct ChatOpenURL: Chat {
    public let message: String
    public let url: URL
    public let withSafariVC: Bool
    public init(url: URL, withSafariVC: Bool = true) {
        self.message = ""
        self.url = url
        self.withSafariVC = withSafariVC
    }
}
