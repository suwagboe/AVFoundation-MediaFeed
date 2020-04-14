//
//  MediaObject.swift
//  AVFoundation-MediaFeed
//
//  Created by Pursuit on 4/13/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import Foundation

// data for the cells
// mediaobject instance can be video or image content

struct MediaObject: Codable {
    // custom objects should have an id and a date object as best practice 
    let imageData: Data?
    let videoUrl: URL?
    let caption: String? // UI so user can enter text
    let id = UUID().uuidString // an idtifier
    let createdDate = Date()
}
