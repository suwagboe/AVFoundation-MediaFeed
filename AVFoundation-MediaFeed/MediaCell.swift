//
//  MediaCell.swift
//  AVFoundation-MediaFeed
//
//  Created by Pursuit on 4/13/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import UIKit

class MediaCell: UICollectionViewCell {
    
    
    @IBOutlet weak var mediaImageVIew: UIImageView!
    
    public func configureCell(for mediaObject: MediaObject){
        // regardless if media is image or video it should have an associated image
        //
        if let imageData = mediaObject.imageData {
                mediaImageVIew.image = UIImage(data: imageData) // takes in data converts to an image
        }
     
        
        // TODO: create a video preview thumbnail
        if let videoURL = mediaObject.videoUrl {
            let image = videoURL.videoPreviewThumbnail() ?? UIImage(systemName: "heart")
            mediaImageVIew.image = image
        }
    }
    
    
    
}
