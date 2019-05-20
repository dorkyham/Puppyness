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
    
    
    var FridgeSoundEffect = AVAudioPlayer()
    var fridgeSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "refrigerator", ofType: "wav")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        addTapGesture(view: meat_view)
        meat_view.shake()
    }
    
    func animateShake(imageView : UIImageView){
        imageView.shakeMeat()
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
