//
//  FridgeViewController.swift
//  Pet Your Puppy
//
//  Created by Annisa Nabila Nasution on 20/05/19.
//  Copyright © 2019 Annisa Nabila Nasution. All rights reserved.
//

import UIKit
import AVKit
import Foundation

class FridgeViewController : UIViewController {
    
    
    
    @IBOutlet var meat_view: UIImageView!
    
    
    @IBOutlet var refrigerator_view: UIImageView!
    
    var soundAlreadyPlayed : Bool! = false
    var FridgeSoundEffect = AVAudioPlayer()
    var fridgeSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "refrigerator", ofType: "wav")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        addTapGesture(view: meat_view)
        pulse(view: meat_view)
        playSound()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainPageSegue"{
            if let viewController = segue.destination as? ViewController {
                viewController.backsoundAlreadyPlayed =  true
                viewController.meatIsSelected = true
            }
        }
    }
    
    func pulse(view : UIImageView) {
        
        UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: [.allowUserInteraction, .repeat, .autoreverse], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1.5, animations: {
                 self.meat_view.transform = CGAffineTransform.identity
            })
            
            }, completion: nil)
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FridgeSoundEffect.stop()
    }
    
    func playSound(){
        FridgeSoundEffect = try! AVAudioPlayer(contentsOf: fridgeSound as URL)
        FridgeSoundEffect.prepareToPlay()
        FridgeSoundEffect.numberOfLoops = -1
        FridgeSoundEffect.play()
    }
    
    func addTapGesture(view : UIImageView){
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(grap:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(grap : UITapGestureRecognizer){
        performSegue(withIdentifier: "mainPageSegue", sender: self)
    }
        
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension UIView {
    func shakeMeat() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = Float.infinity
        animation.duration = 0.8
        animation.values = [-10.0, 10.0, -10.0, 10.0, -5.0, 5.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
