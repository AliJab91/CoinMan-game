//
//  ViewController.swift
//  CoreMLFun
//
//  Created by Administrator on 4/16/18.
//  Copyright © 2018 Ali Jaber. All rights reserved.
//

import UIKit
import CoreML
import Vision
class ViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    var imagePicker = UIImagePickerController()
    let resnetModel = Resnet50 ()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        if let image = imageView.image {
            imageProccess(image: image)
        }
    }
        // Do any additional setup after loading the view, typically from a nib.


    func imageProccess(image: UIImage)  {
        if let model = try? VNCoreMLModel(for: self.resnetModel.model) {
            let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
                if let results = request.results as? [VNClassificationObservation] {
                    for classification in results {
                        print("ID: \(classification.identifier) Confidence : \(classification.confidence) ")
                    }
                    self.descriptionLabel.text = results.first?.identifier
                    if let confidence = results.first?.confidence  {
                        self.percentageLabel.text = "\(confidence * 100.0)%"
                    }
                }
            })
            if let imageData = UIImagePNGRepresentation(image) {
                let handler = VNImageRequestHandler(data: imageData, options: [:])
                try? handler.perform([request])
            }
        }

}

    @IBAction func cameraPresser(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func photoLibraryPresser(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = selectedImage
            imageProccess(image:selectedImage )
        }

        picker.dismiss(animated: true, completion: nil)
    }



}

