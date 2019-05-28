//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet public var filterButton: UIButton!
    @IBOutlet public var editButton: UIButton!
    @IBOutlet public var compareButton: UIButton!
    @IBOutlet public var imageView: UIImageView!
    @IBOutlet public var compareImageView: UIImageView!
    @IBOutlet public var secondaryMenu: UIView!
    @IBOutlet public var bottomMenu: UIView!
    @IBOutlet public var sliderMenu: UIView!
    @IBOutlet public var imageContainerView: UIView!

    @IBOutlet var imageContainerTapRecognizer: UITapGestureRecognizer!
    
    public var output: Presenter!

    @IBAction func onRedFilter(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        output.updateFiltersState(isSelected: sender.isSelected, filter: FiltersState.redFilter)
    }
    
    @IBAction func onGreenFilter(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        output.updateFiltersState(isSelected: sender.isSelected, filter: FiltersState.greenFilter)
    }
    
    @IBAction func onBlueFilter(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        output.updateFiltersState(isSelected: sender.isSelected, filter: FiltersState.blueFilter)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Should be moved to separate Assembly class
        output = Presenter()
        output.output = self
        
        output.initializeImage()
        
        secondaryMenu.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        
        sliderMenu.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        sliderMenu.translatesAutoresizingMaskIntoConstraints = false
        
        compareButton.isEnabled = false
    }
    
    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        output.share()
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: AnyObject) {
        output.newPhoto()
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        
        self.present(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let albumPicker = UIImagePickerController()
        albumPicker.delegate = self
        albumPicker.sourceType = .photoLibrary
        
        self.present(albumPicker, animated: true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if (sender.isSelected) {
            hideSecondaryMenu()
            sender.isSelected = false
        } else {
            showSecondaryMenu()
            hideSlider()
            sender.isSelected = true
        }
    }
    
    @IBAction func onCompare(_ sender: UIButton) {
        if (sender.isSelected) {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
        
        output.toggleCompare(sender.isSelected)
    }
    
    @IBAction func onEdit(_ sender: UIButton) {
        if (sender.isSelected) {
            self.hideSlider()
            sender.isSelected = false
        } else {
            sender.isSelected = true
            self.hideSecondaryMenu()
            self.showSlider()
        }
    }
    
    @IBAction func onSliderChange(_ sender: UISlider) {
        self.output.processor?.multiplier = Int(sender.value)
        self.output.updateImageFilters()
    }
    
    @IBAction func onImageContainerTap(_ sender: UITapGestureRecognizer) {
        self.onCompare(self.compareButton)
    }

    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraint(equalToConstant: 80)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }
    
    func hideSecondaryMenu() {
        self.filterButton.isSelected = false
        UIView.animate(withDuration: 0.4, animations: {
            self.secondaryMenu.alpha = 0
        }) { completed in
            if completed == true {
                self.secondaryMenu.removeFromSuperview()
            }
        }
    }
    
    func showSlider() {
        view.addSubview(sliderMenu)
        let bottomConstraint = sliderMenu.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = sliderMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = sliderMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let heightConstraint = sliderMenu.heightAnchor.constraint(equalToConstant: 80)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.sliderMenu.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.sliderMenu.alpha = 1.0
        }
    }
    
    func hideSlider() {
        self.editButton.isSelected = false
        UIView.animate(withDuration: 0.4, animations: {
            self.sliderMenu.alpha = 0
        }) { completed in
            if completed == true {
                self.sliderMenu.removeFromSuperview()
            }
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        output.didFinishPickingMediaWithInfo(info: info)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        output.didCancelPickingMedia()
    }
}

