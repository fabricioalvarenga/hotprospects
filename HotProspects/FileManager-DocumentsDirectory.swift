//
//  FileManager-DocumentsDirectory.swift
//  HotProspects
//
//  Created by FABRICIO ALVARENGA on 26/10/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
