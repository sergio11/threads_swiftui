//
//  Mapper.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

protocol Mapper {
    associatedtype Input
    associatedtype Output
    
    func map(_ input: Input) -> Output
}
