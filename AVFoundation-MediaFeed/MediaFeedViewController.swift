//
//  ViewController.swift
//  AVFoundation-MediaFeed
//
//  Created by Pursuit on 4/13/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import UIKit
import AVFoundation // video playback is done on a (CALayer) - all views are backed by a CALayer e.x if we want to make a view rounded we can only do this using the CALayer of that view... ex someView.layer.cornerRadius = 10
import AVKit //  video playback is done with  AVPlayerViewController

class MediaFeedViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var videoButton: UIBarButtonItem!
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    
    private lazy var imagePickerController: UIImagePickerController = {
        let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)
        let pickerController = UIImagePickerController()
        pickerController.mediaTypes = mediaTypes ?? ["kUTTypeImage"]
        pickerController.delegate = self
        // need to conform to the delegate for above in order for it to work and take out the errors
       return pickerController
    }()
    
    private var mediaObjects = [MediaObject]() {
        didSet{
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureNeededUIThings()
        
    }
    
    private func configureNeededUIThings(){
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                     videoButton.isEnabled = false
                 }
    }
    
    
    @IBAction func videoButtonPressed(_ sender: UIBarButtonItem  ) {
        
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true)
        
    }
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIBarButtonItem) {
        
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    

}

//MARK: UICollectionViewDataSource Methods

extension MediaFeedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaCell", for: indexPath) as? MediaCell else {
            fatalError("couldn't dequeue a media cell ")
        }
        
        let selectedImage = mediaObjects[indexPath.row]
        cell.configureCell(for: selectedImage)
        return cell
    }
    
    // need a view for the header view and need to register it
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // give back a view for the one I am looking at.
        // dequeqble view
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath) as? HeaderView else {
            fatalError("couldnt dequeue to headerView ")
            }
        return headerView
    }
        
    
}

//MARK: UICollectionViewDelegate Methods


extension MediaFeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // when user clicks on a cell what do we want to happen
        
        // AVPlayer allows you to access the necessary items
              let selectedVideoMedia = mediaObjects[indexPath.row]
              guard let videoUrl = selectedVideoMedia.videoUrl else {
                  return
              }
        
         // NEED AVKIT in order to access the following properties
        let playerViewController = AVPlayerViewController()
        let player = AVPlayer(url: videoUrl)
        playerViewController.player = player
        present(playerViewController, animated: true){
            // play video automatically
            player.play() // This will automatically play !!
        }


      
       // present(playerViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width
        let itemHeight: CGFloat = maxSize.height * 0.4
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
                return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // this allows for the size for the header to be added ... this is needed
        
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height * 0.3)
    }
}

extension MediaFeedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // inside of a dictionary
        
        // things we want in a info dictionary
        // infoKey.originalImage - UIImage
        // InfoKey.mediaType - String
        // InfoKey.mediaURL - URL
        
        // its optional so wanna unwrapp it
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else {
            return
        }
        
        switch mediaType {
        case "public.image":
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
                let imageData = originalImage.jpegData(compressionQuality: 1.0){
                // create a media object and convert to a data object
                 let newMediaObject = MediaObject(imageData: imageData, videoUrl: nil, caption: nil)
                mediaObjects.append(newMediaObject)
            }
        case "public.movie":
            if let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                print("media: \(mediaURL)")
                // make sure in the model it follows the same type that it needs to be
                let mediaObject = MediaObject(imageData: nil, videoUrl: mediaURL, caption: nil)
                
                mediaObjects.append(mediaObject)
            }
        default :
            print("unsuported mediaType")
        }
        
      //  print("mediaType: \(mediaType)") // "public.movie", "public.image"
        
        picker.dismiss(animated: true)
    }
}
