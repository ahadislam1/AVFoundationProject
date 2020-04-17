//
//  MathViewController.swift
//  MathGame
//
//  Created by Oscar Victoria Gonzalez  on 4/16/20.
//  Copyright © 2020 Oscar Victoria Gonzalez . All rights reserved.
//

import UIKit
import Vision
import AVFoundation

class MathViewController: UIViewController {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var operationLabel: UILabel!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var audioPlayer = AVAudioPlayer()
    var wrongAudioPlayer = AVAudioPlayer()
    var doneAudioPlayer = AVAudioPlayer()
    
    var someOperation = Operations()
    
    var correctAnswers = 0
    var wrongAnswers = 0
    var totalAnswers = 0
    
    var textRecognitionRequest = VNRecognizeTextRequest()
    var recognizedText = ""
    var selectedImage = UIImage()
    var someString = ""
    
    var lastPoint = CGPoint.zero
    var color = UIColor.black
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        displayOperation()
        processImage()
        playAudioFromProject()
        playAudioFromProjectTwo()
        playFinalAudio()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideButtons()
        guard let touch = touches.first else {
            return
        }
        swiped = false
        lastPoint = touch.location(in: view)
    }
    
    
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        tempImageView.image?.draw(in: view.bounds)
        
        
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        
        
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
    
    func displayOperation() {
        operationLabel.text = "\(someOperation.a) \(someOperation.operationator) \(someOperation.b)"
    }
    
    func displayRandomOperation() {
        someOperation.randomize()
        operationLabel.text = "\(someOperation.a) \(someOperation.operationator) \(someOperation.b)"
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
                        self.someString = self.recognizedText
                    }
                    
                }
            }
        })
        
    }
    
    func captureImage() {
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
    
    private func playAudioFromProject() {
        let sound = Bundle.main.path(forResource: "correct", ofType: "mp3")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        } catch {
            print("error")
        }
    }
    
    private func playAudioFromProjectTwo() {
        let sound = Bundle.main.path(forResource: "wrong", ofType: "mp3")
        
        do {
            wrongAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        } catch {
            print("error")
        }
    }
    
    private func playFinalAudio() {
          let sound = Bundle.main.path(forResource: "done", ofType: "mp3")
          
          do {
              doneAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
          } catch {
              print("error")
          }
      }
    
    func showAlert() {
        let alert = UIAlertController(title: "Game Over", message: "Final correct answers \(correctAnswers) \n Final wrong answers \(wrongAnswers)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    @IBAction func resetPressed(_ sender: Any) {
        mainImageView.image = nil
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        if totalAnswers < 5 {
            hideButtons()
            captureImage()
            if someString == "\(someOperation.solution())" {
                mainImageView.image = nil
                operationLabel.isHidden = false
                audioPlayer.play()
                view.backgroundColor = .systemGreen
                correctAnswers += 1
                totalAnswers += 1
                displayRandomOperation()
            } else {
                mainImageView.image = nil
                operationLabel.isHidden = false
                wrongAudioPlayer.play()
                view.backgroundColor = .systemRed
                wrongAnswers += 1
                totalAnswers += 1
                displayRandomOperation()
            }
        } else {
            doneAudioPlayer.play()
            showAlert()
            mainImageView.image = nil
            operationLabel.isHidden = false
            displayRandomOperation()
            wrongAnswers = 0
            correctAnswers = 0
            totalAnswers = 0
        }
        
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
