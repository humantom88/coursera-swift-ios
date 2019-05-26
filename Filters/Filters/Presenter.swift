//
//  Presenter.swift
//  Filters
//
//  Created by Tom Belov on 25/05/2019.
//  Copyright © 2019 Tom Belov. All rights reserved.
//

import UIKit

class Presenter: ViewOutput {
    public var output: ViewController!
    public var processor: Processor?
    public var filtersState: FiltersState = FiltersState.none

    public func updateImageFilters() {
        if (filtersState.rawValue > 0) {
            output.compareButton.isEnabled = true
            guard let image = output.compareImageView.image else {
                return
            }
            
            output.imageView.image = processor?.processUIImage(image: image, filteredState: filtersState)
            showComareImageViewWithAnimation()
        } else {
            output.compareButton.isEnabled = false
            output.imageView.image = UIImage(named: "scenery")
        }
        showImageViewWithAnimation()
    }
    
    public func showImageViewWithAnimation () {
        self.output.imageView.alpha = 1.0
        UIView.animate(withDuration: 0.5) {
            self.output.compareImageView.alpha = 0.0
        }
    }
    
    public func showComareImageViewWithAnimation () {
        self.output.compareImageView.alpha = 1.0
        UIView.animate(withDuration: 0.5) {
            self.output.imageView.alpha = 0.0
        }
    }
    
    public func initializeImage () {
        output.imageView.image = UIImage(named: "scenery")
        output.compareImageView.image = UIImage(named: "scenery")
        processor = Processor(average: Average.getAverageFromUIImage(uiImage: output.imageView.image!)!)
    }
    
    public func share() {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", output.compareButton.isSelected ? output.compareImageView.image! : output.imageView.image!], applicationActivities: nil)
        output.present(activityController, animated: true, completion: nil)
    }
    
    public func newPhoto() {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.output.showCamera()
            self.dropFiltersState()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .default, handler: { action in
            self.output.showAlbum()
            self.dropFiltersState()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        output.present(actionSheet, animated: true, completion: nil)
    }
    
    public func didFinishPickingMediaWithInfo(info: [UIImagePickerController.InfoKey : Any]) {
        output.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.output.imageView.image = image
            self.output.compareImageView.image = image.copy() as? UIImage
            processor = Processor(average: Average.getAverageFromUIImage(uiImage: image)!)
            filtersState = FiltersState(rawValue: 0)
        }
    }
    
    public func didCancelPickingMedia () {
        output.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        output.dismiss(animated: true, completion: nil)
    }
    
    func dropFiltersState() {
        filtersState = FiltersState.none
    }
    
    public func toggleCompare(_ selected: Bool) {
        if (selected) {
            showComareImageViewWithAnimation()
        } else {
            showImageViewWithAnimation()
        }
    }
    
    public func updateFiltersState(isSelected: Bool, filter: FiltersState) {
        if (isSelected) {
            self.filtersState = self.filtersState.union(filter)
        } else {
            self.filtersState.remove(filter)
        }
        
        self.output.compareButton.isSelected = false
        self.updateImageFilters()
    }
    
}
