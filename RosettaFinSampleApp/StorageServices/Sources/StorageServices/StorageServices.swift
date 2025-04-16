//
//  StorageServices.swift
//  StorageServices
//
//  Created by Kenny Cabral on 4/16/25.
//

import Combine
import Foundation
import SwiftData
import DataModels

@MainActor
public final class StorageServices {
    public static let shared = StorageServices()
    
    public let massStorageManager = MassStorageManager()
    
}
