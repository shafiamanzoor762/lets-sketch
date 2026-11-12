//
//  FileStorageService.swift
//  lets-sketch
//
//  Created by Shafia Manzoor on 19/06/2026.
//


import UIKit

/// Handles writing/reading the PNG previews.
/// documents directory used
public final class FileStorageService {

//    public static let shared = FileStorageService()
    nonisolated(unsafe) public static let shared = FileStorageService()

    private init() {}

    private var fileManager: FileManager {
        FileManager.default
    }

    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    public func savePNG(_ image: UIImage, fileName: String) -> String? {
        guard let data = image.pngData() else { return nil }
        let finalName = fileName.hasSuffix(".png") ? fileName : "\(fileName).png"
        let url = documentsDirectory.appendingPathComponent(finalName)
        do {
            try data.write(to: url, options: .atomic)
            return finalName
        } catch {
            print("Could not save preview image: \(error)")
            return nil
        }
    }

    public func loadImage(fileName: String) -> UIImage? {
        let url = documentsDirectory.appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
}
