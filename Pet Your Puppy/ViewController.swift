//
//  ViewController.swift
//  Pet Your Puppy
//
//  Created by Annisa Nabila Nasution on 18/05/19.
//  Copyright © 2019 Annisa Nabila Nasution. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    @IBOutlet var dog_image_view: UIImageView!
    
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    
    @IBOutlet var headSlappedBoundary: UIView!
    @IBOutlet var gestureBoundary: UIView!
    @IBOutlet var panRecognizer: UIPanGestureRecognizer!
    var idle_images : [UIImage]!
    var happy_images : [UIImage]!
    var slapped_images : [UIImage]!
    
    var AudioPlayer = AVAudioPlayer()
    var PantEffectPlayer = AVAudioPlayer()
    var SlapEffectPlayer = AVAudioPlayer()
    //sound
    let dog_pant = NSURL(fileURLWithPath: Bundle.main.path(forResource: "dog panting", ofType: "wav")!)
    let slap =  NSURL(fileURLWithPath: Bundle.main.path(forResource: "Slap", ofType: "wav")!)
    var backgroundAnimated : Void!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idle_images = createImageArray(total: 3, imagePrefix: "Dog Idle")
        happy_images = createImageArray(total: 3, imagePrefix: "Dog Touge out")
        slapped_images = createImageArray(total: 2, imagePrefix: "Dog slapped")
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
        dog_image_view.animationImages = images
        dog_image_view.animationDuration = 0.4
        dog_image_view.animationRepeatCount = 0
        dog_image_view.startAnimating()
    }
    
    func animateReaction(imageView : UIImageView, images : [UIImage]){
        dog_image_view.animationImages = images
        dog_image_view.animationDuration = 0.2
        dog_image_view.animationRepeatCount = 0
        dog_image_view.isUserInteractionEnabled = true
        dog_image_view.startAnimating()
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
        switch rub.state {
        case .began:
            animate(imageView: dog_image_view, images: happy_images)
            PantEffectPlayer.prepareToPlay()
            PantEffectPlayer.numberOfLoops = -1
            PantEffectPlayer.play()
            backgroundAnimated = UIView.animate(withDuration: 1, delay: 0, options: .transitionCrossDissolve, animations: {
                self.view.backgroundColor = #colorLiteral(red: 1, green: 0.6257035136, blue: 0.6577243209, alpha: 1)
            }, completion: nil)
            break
        case .changed: break
        case .ended:
            PantEffectPlayer.pause()
            animate(imageView: dog_image_view, images: idle_images)
            backgroundAnimated = UIView.animate(withDuration: 1, delay: 0, options: .transitionCrossDissolve, animations: {
                self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }, completion: nil)
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
