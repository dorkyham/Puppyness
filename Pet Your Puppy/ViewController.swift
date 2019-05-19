//
//  ViewController.swift
//  Pet Your Puppy
//
//  Created by Annisa Nabila Nasution on 18/05/19.
//  Copyright © 2019 Annisa Nabila Nasution. All rights reserved.
//

import UIKit
import AVKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet var dog_image_view: UIImageView!
    
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    
    @IBOutlet var heart_image_view: UIImageView!
    @IBOutlet var headSlappedBoundary: UIView!
    @IBOutlet var gestureBoundary: UIView!
    @IBOutlet var panRecognizer: UIPanGestureRecognizer!
    var idle_images : [UIImage]!
    var happy_images : [UIImage]!
    var slapped_images : [UIImage]!
    var bark_images : [UIImage]!
    var heart_images : [UIImage]!
    
    var BarkEffectPlayer = AVAudioPlayer()
    var BubbleEffectPlayer = AVAudioPlayer()
    var AudioPlayer = AVAudioPlayer()
    var PantEffectPlayer = AVAudioPlayer()
    var SlapEffectPlayer = AVAudioPlayer()
    //sound
    let dog_pant = NSURL(fileURLWithPath: Bundle.main.path(forResource: "dog panting", ofType: "wav")!)
    let slap =  NSURL(fileURLWithPath: Bundle.main.path(forResource: "Slap", ofType: "wav")!)
    let bark = NSURL(fileURLWithPath: Bundle.main.path(forResource: "puppy_bark2", ofType: "mp3")!)
    let bubble = NSURL(fileURLWithPath: Bundle.main.path(forResource: "Bubbles", ofType: "mp3")!)
    var backgroundToPinkAnimated : Void!
    var backgroundToWhiteAnimated : Void!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heart_images = createImageArray(total: 4, imagePrefix: "heart")
        idle_images = createImageArray(total: 3, imagePrefix: "Dog Idle")
        happy_images = createImageArray(total: 3, imagePrefix: "Dog Touge out")
        slapped_images = createImageArray(total: 2, imagePrefix: "Dog slapped")
        bark_images = createImageArray(total: 9, imagePrefix: "Dog Bark")
        animate(imageView: dog_image_view, images: idle_images)
        addTapGesture(view: headSlappedBoundary)
        addPanGesture(view: dog_image_view)
        playSong()
    }
    
    func playSong(){
        let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: "Dog_and_Pony_Show", ofType: "mp3")!)
        AudioPlayer = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
        AudioPlayer.prepareToPlay()
        AudioPlayer.numberOfLoops = -1
        AudioPlayer.play()
        
        BubbleEffectPlayer = try! AVAudioPlayer(contentsOf: bubble as URL)
        BarkEffectPlayer = try! AVAudioPlayer(contentsOf: bark as URL)
        PantEffectPlayer = try! AVAudioPlayer(contentsOf: dog_pant as URL)
        
        SlapEffectPlayer = try! AVAudioPlayer(contentsOf: slap as URL)
    }
    
    func createImageArray(total : Int, imagePrefix : String)-> [UIImage]{
        var imageArray : [UIImage] = []
        
        for imageCount in 1...total {
            let imageName = "\(imagePrefix) \(imageCount).png"
            let image = UIImage(named: imageName)!
            
            imageArray.append(image)
        }
        return imageArray
    }

    func animate(imageView : UIImageView, images : [UIImage]){
        imageView.animationImages = images
        imageView.animationDuration = 0.4
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
    }
    
    func animateReaction(imageView : UIImageView, images : [UIImage]){
        imageView.animationImages = images
        imageView.animationDuration = 0.2
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
    }
    
    func animateBark(imageView : UIImageView, images : [UIImage]){
        imageView.animationImages = images
        imageView.animationDuration = 0.7
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        imageView.stopAnimating()
        }
    }
    
    func addPanGesture(view : UIImageView){
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(rub:)));
        view.isUserInteractionEnabled = true
        panRecognizer.delegate = self
        view.addGestureRecognizer(panRecognizer)
    }
    
    func addTapGesture(view : UIView){
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(slap:)))
        view.isUserInteractionEnabled = true
        tapRecognizer.delegate = self
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func handlePan(rub : UIPanGestureRecognizer){
        let start : Double = Double(DispatchTime.now().uptimeNanoseconds)
        var end : Double = 0
        var time_interval : Double
        switch rub.state {
        case .began:
            animate(imageView: dog_image_view, images: happy_images)
            PantEffectPlayer.prepareToPlay()
            PantEffectPlayer.numberOfLoops = -1
            PantEffectPlayer.play()
            backgroundToPinkAnimated = UIView.animate(withDuration:  4, delay: 0, options: .transitionCrossDissolve, animations: {
                self.view.backgroundColor = #colorLiteral(red: 0.9609596133, green: 0.5441862345, blue: 0.5523681641, alpha: 1)
            }, completion: {
               (finished: Bool) in
                    rub.state = .ended
            });
            break
        case .changed: break
        case .ended:
            end = Double(DispatchTime.now().uptimeNanoseconds)
            time_interval = end - start
            if time_interval >= 4 {
                self.PantEffectPlayer.pause()
                self.animateBark(imageView: self.dog_image_view, images: self.bark_images)
                self.BarkEffectPlayer.play()
                self.animate(imageView: self.heart_image_view, images: self.heart_images)
                self.BubbleEffectPlayer.play()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.animate(imageView: self.dog_image_view, images: self.idle_images)
                    
                    self.backgroundToWhiteAnimated = UIView.animate(withDuration: 3, delay: 0, options: .transitionCrossDissolve, animations: {
                        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }, completion: nil);
                    self.BubbleEffectPlayer.pause()
                    self.heart_image_view.stopAnimating()
            }
            }else{
            PantEffectPlayer.pause()
            animate(imageView: dog_image_view, images: idle_images)
            backgroundToWhiteAnimated = UIView.animate(withDuration:3, delay: 0, options: .transitionCrossDissolve, animations: {
                self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }, completion: nil);
            }
            break
        case .possible: break
        case .cancelled: break
        case .failed: break
        @unknown default: break
        }
    }
    @objc func handleTap(slap : UITapGestureRecognizer){
        if slap.state == .ended || slap.state == .possible || slap.state == .changed {
            animateReaction(imageView: dog_image_view, images: slapped_images)
            SlapEffectPlayer.play()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // Change `2.0` to the desired number of seconds.
            //            self.animationSlappedView.isHidden = true
            self.animate(imageView: self.dog_image_view, images: self.idle_images)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
