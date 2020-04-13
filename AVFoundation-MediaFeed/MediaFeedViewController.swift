//
//  ViewController.swift
//  AVFoundation-MediaFeed
//
//  Created by Pursuit on 4/13/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import UIKit

class MediaFeedViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var videoButton: UIBarButtonItem!
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    
    private lazy var imagePickerController: UIImagePickerController = {
        let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)
        let pickerController = UIImagePickerController()
        pickerController.mediaTypes = mediaTypes ?? ["kuTTypesImage"]
        pickerController.delegate = self
        // need to conform to the delegate for above in order for it to work and take out the errors
       return pickerController
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureCollectionView()
       
    }
    
    private func configureCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    @IBAction func videoButtonPressed(_ sender: UIBarButtonItem                        ) {
        
        
    }
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIBarButtonItem) {
    }
    

}

//MARK: UICollectionViewDataSource Methods

extension MediaFeedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaCell", for: indexPath)
        
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
        // infoKey.originalImage
        
        // its optional so wanna unwrapp it
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else {
            return
        }
        
        print("mediaType: \(mediaType)")
    }
}
