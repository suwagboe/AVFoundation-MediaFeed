//
//  URL+VideoPreviewThumbNail.swift
//  AVFoundation-MediaFeed
//
//  Created by Pursuit on 4/13/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import UIKit
import AVFoundation // because we are returning some image

extension URL {
    
    public func videoPreviewThumbnail() -> UIImage? {
        
        // create an AVAsset instance
        // an asset with a url
        // e.x mediaObject.videoURL -> this is what self is refereing to the INSTANCE of the URL
        let asset = AVAsset(url: self) // self is the URL instance
        
        // The AVAssetImageGenerator is an AVFoundation class that converts a given media url to  Image
        
        let assetGenerator = AVAssetImageGenerator(asset: asset)
        
        // we want to maintain the aspect ration of the video
        assetGenerator.appliesPreferredTrackTransform = true
        
        // create a time stamp of the need area/ location inside of the video
        
        // we will use a CMTime to genereate a given time stamp
        // CMTime is apart of core media
        let timeStamp = CMTime(seconds: 1, preferredTimescale: 60)// get me the first second of the video.
        var image: UIImage?
        do {
            let cgimage = try assetGenerator.copyCGImage(at: timeStamp, actualTime: nil)
            image = UIImage(cgImage: cgimage)
            
            // UIView
            // layer
            
            // lower level API dont know about UIKit, AVKit
            // change the color of a UIView border
            // e.x someView.layer.borderColor = UIColor.green .CGColor
        }catch {
            print("failed to generate image: \(error)")
        }
        
        return image
    }
}
