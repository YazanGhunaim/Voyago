//
//  VoyagoLogger.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 1/12/25.
//

import Foundation
import OSLog

/// Singleton logger class
class VoyagoLogger {
    let logger: Logger

    // shared instance
    static let shared = VoyagoLogger()

    // disable constructor to make it singleton
    private init() { self.logger = Logger() }
}
