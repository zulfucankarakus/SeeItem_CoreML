//
//  ViewController.swift
//  SeeFood
//
//  Created by Zülfücan Karakuş on 17.04.2023.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePıcker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imagePıcker.delegate = self
        imagePıcker.sourceType = .camera
        imagePıcker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPıckedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            imageView.image = userPıckedImage
            
            guard let ciimage = CIImage(image: userPıckedImage) else{
                fatalError("Could not convert UIImage into CIImage")
            }
            detec(image: ciimage)
        }
        
        imagePıcker.dismiss(animated: true,completion: nil)
        
    }
    
    func detec(image:CIImage){
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
            fatalError("Loading CoreML Model Failing")
        }
        
        let request = VNCoreMLRequest(model: model) { (request,error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            
            if let firstResault = results.first{
                self.navigationItem.title = firstResault.identifier
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
            try handler.perform([request])
        }
        catch{
            print(error)
        }
        
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePıcker, animated: true, completion: nil)
        
    }
    
}

