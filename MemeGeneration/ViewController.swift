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
    var renderer = UIGraphicsImageRenderer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func importPicture(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func setTopText(_ sender: Any) {
        let topTextAC = UIAlertController(title: "Top text", message: "Insert a text to go at the top of the meme", preferredStyle: .alert)
        topTextAC.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak topTextAC] _ in
            guard let topText = topTextAC?.textFields?[0].text else { return }
            self?.topText = topText
            print(self?.topText ?? "")
        }
        
        topTextAC.addAction(submitAction)
        present(topTextAC, animated: true)
    }
    
    @IBAction func setBottomText(_ sender: Any) {
        let bottomTextAC = UIAlertController(title: "Bottom text", message: "Insert a text to go at the bottom of the meme", preferredStyle: .alert)
        bottomTextAC.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak bottomTextAC] _ in
            guard let bottomText = bottomTextAC?.textFields?[0].text else { return }
            self?.bottomText = bottomText
            print(self?.bottomText ?? "")
        }
        
        bottomTextAC.addAction(submitAction)
        present(bottomTextAC, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        imageView.image = image
    }
}

