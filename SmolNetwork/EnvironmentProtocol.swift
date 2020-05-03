//
//  EnvironmentProtocol.swift
//  SmolNetwork
//
//  Created by Razvan Litianu on 02/05/2020.
//  Copyright © 2020 Razvan Litianu. All rights reserved.
//

import Foundation

/// Protocol to which environments must conform.
public protocol EnvironmentProtocol {
    /// The default HTTP request headers for the environment.
    var headers: RequestHeaders? { get }
    
    /// The base URL of the environment.
    var baseURL: String { get }
}

extension EnvironmentProtocol {
    public var headers: RequestHeaders? { return nil }
}
