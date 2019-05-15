//
//  ViewController.swift
//  MemeGeneration
//
//  Created by Michele Galvagno on 14/05/2019.
//  Copyright © 2019 Michele Galvagno. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    var topText: String?
    var bottomText: String?
    var chosenImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
    }
    
    func render() {
        let renderer = UIGraphicsImageRenderer(size: imageView.frame.size)
        
        let image = renderer.image { (ctx) in
            // Render image
            chosenImage?.draw(in: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))
            
            // Prepare for rendering text
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineBreakMode = .byWordWrapping
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Marker Felt", size: 40) as Any,
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
            
            let textFrameHeight: CGFloat = 100
            let xOffset: CGFloat = 10
            let textFrameWidth: CGFloat = imageView.frame.width - xOffset
            let yOffset: CGFloat = 10
            
            if let topText = topText {
                let attributedString = NSAttributedString(string: topText, attributes: attributes)
                
                attributedString.draw(with: CGRect(x: xOffset, y: yOffset, width: textFrameWidth, height: textFrameHeight), options: .usesLineFragmentOrigin, context: nil)
            }
            
            if let bottomText = bottomText {
                let attributedString = NSAttributedString(string: bottomText, attributes: attributes)
                
                attributedString.draw(with: CGRect(x: xOffset, y: imageView.frame.height - (yOffset * 6), width: textFrameWidth, height: textFrameHeight), options: .usesLineFragmentOrigin, context: nil)
            }
        }
        
        imageView.image = image
    }

    @IBAction func importPicture(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func setTopText(_ sender: Any) {
        guard imageView.image != nil else {
            let noImageAC = UIAlertController(title: "No image found!", message: "Choose an image before trying to add text to it!", preferredStyle: .alert)
            noImageAC.addAction(UIAlertAction(title: "OK", style: .default))
            present(noImageAC, animated: true)
            
            return
        }
        
        let topTextAC = UIAlertController(title: "Top text", message: "Insert a text to go at the top of the meme", preferredStyle: .alert)
        topTextAC.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak topTextAC] _ in
            guard let topText = topTextAC?.textFields?[0].text else { return }
            self?.topText = topText
            self?.render()
        }
        
        topTextAC.addAction(submitAction)
        present(topTextAC, animated: true)
    }
    
    @IBAction func setBottomText(_ sender: Any) {
        guard imageView.image != nil else {
            let noImageAC = UIAlertController(title: "No image found!", message: "Choose an image before trying to add text to it!", preferredStyle: .alert)
            noImageAC.addAction(UIAlertAction(title: "OK", style: .default))
            present(noImageAC, animated: true)
            
            return
        }
        
        let bottomTextAC = UIAlertController(title: "Bottom text", message: "Insert a text to go at the bottom of the meme", preferredStyle: .alert)
        bottomTextAC.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak bottomTextAC] _ in
            guard let bottomText = bottomTextAC?.textFields?[0].text else { return }
            self?.bottomText = bottomText
            self?.render()
        }
        
        bottomTextAC.addAction(submitAction)
        present(bottomTextAC, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        chosenImage = image
        dismiss(animated: true)
        
        render()
    }
    
    @objc func shareImage() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            let noImageAC = UIAlertController(title: "No image found!", message: "Choose an image before trying share it!", preferredStyle: .alert)
            noImageAC.addAction(UIAlertAction(title: "OK", style: .default))
            present(noImageAC, animated: true)
            
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: [])
        activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(activityVC, animated: true)
    }
}
