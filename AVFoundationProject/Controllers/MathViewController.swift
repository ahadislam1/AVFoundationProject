//
//  MathViewController.swift
//  MathGame
//
//  Created by Oscar Victoria Gonzalez  on 4/16/20.
//  Copyright © 2020 Oscar Victoria Gonzalez . All rights reserved.
//

import UIKit
import Vision

class MathViewController: UIViewController {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var operationLabel: UILabel!
    
    var someOperation = Operations()
    
    func displayOperation() {
        operationLabel.text = "\(someOperation.a) \(someOperation.operationator) \(someOperation.b)"
    }
    
    func displayRandomOperation() {
        someOperation.randomize()
        operationLabel.text = "\(someOperation.a) \(someOperation.operationator) \(someOperation.b)"
    }

    
    var textRecognitionRequest = VNRecognizeTextRequest()
    var recognizedText = ""
    var selectedImage = UIImage()
    var someString = ""
    
    var lastPoint = CGPoint.zero
    var color = UIColor.black
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayOperation()
        processImage()
    }
    
    func hideButtons() {
        resetButton.isHidden = true
        button.isHidden = true
        shareButton.isHidden = true
        operationLabel.isHidden = true
    }
    
    func unhideButtons() {
        resetButton.isHidden = false
        button.isHidden = false
        shareButton.isHidden = false
        operationLabel.isHighlighted = false
    }
    
    
    func processImage() {
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
            if let results = request.results, !results.isEmpty {
                if let requestResults = request.results as? [VNRecognizedTextObservation] {
                    self.recognizedText = ""
                    for observation in requestResults {
                        guard let candidiate = observation.topCandidates(1).first else { return }
                        self.recognizedText += candidiate.string
                        //            self.recognizedText += "\n"
                        self.someString = self.recognizedText
                        //            print(self.recognizedText)
                    }
                    
                }
            }
        })
        
    }
    
    func documentCameraViewController() {
        //    let image = UIImage(named: "three")?.cgImage
        //    mainImageView.image = mainImageView.image?.cgImage
        let screenShot = self.view.takeScreenshot()
        mainImageView.image = screenShot
        let image = mainImageView.image?.cgImage
        
        let handler = VNImageRequestHandler(cgImage: image!, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
        } catch {
            print(error)
        }
    }
    
    //  func saveImage() {
    //    UIImageWriteToSavedPhotosAlbum(mainImageView.image!, self, nil, nil)
    //  }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideButtons()
        guard let touch = touches.first else {
            return
        }
        swiped = false
        lastPoint = touch.location(in: view)
    }
    
    
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        // 1
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        tempImageView.image?.draw(in: view.bounds)
        
        // 2
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        
        // 3
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(color.cgColor)
        
        
        context.strokePath()
        
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        
        swiped = true
        let currentPoint = touch.location(in: view)
        drawLine(from: lastPoint, to: currentPoint)
        
 
        lastPoint = currentPoint
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            drawLine(from: lastPoint, to: lastPoint)
        }
        
        
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
        tempImageView?.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        unhideButtons()
        tempImageView.image = nil
    }
    
    
    @IBAction func resetPressed(_ sender: Any) {
        mainImageView.image = nil
    }
    
    @IBAction func sharePressed(_ sender: Any) {
        hideButtons()
        documentCameraViewController()
        if someString == "\(someOperation.solution())" {
            mainImageView.image = nil
            operationLabel.isHidden = false
            view.backgroundColor = .systemGreen
            displayRandomOperation()
            print("Correct!")
        } else {
            mainImageView.image = nil
            operationLabel.isHidden = false
            view.backgroundColor = .systemRed
            displayRandomOperation()
            print("Wrong")
        }
       
        print("current number is \(recognizedText)")
    }

}

extension UIView {
    func takeScreenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
    
}
