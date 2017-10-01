//
//  ViewController.swift
//  Clover
//
//  Created by Geoffrey Gonzales on 10/1/17.
//  Copyright © 2017 Sunlight. All rights reserved.
//

import UIKit

class ViewController : UIViewController
{
          @IBOutlet weak var countLabel: UILabel!
          @IBOutlet weak var clearButton: UIButton!
          @IBOutlet weak var cancelClear: UIButton!
          var count = 0
          
          // 3D Touch Objects
          var impactFinished = false
          let generatorHeavy = UIImpactFeedbackGenerator(style: .heavy)
          let generatorLight = UIImpactFeedbackGenerator(style : .light)
          let pressureThreshold : CGFloat = 0.3
          
          override func viewDidLoad()
          {
                    super.viewDidLoad()
          }
          
          func updateLabel(text : Any)
          {
                    countLabel.text = "\(text)"
          }
          
          // 3d Touch For iPhone 6 And Newer
          // Preparing The Fedback Engine To Generate Feedback For Less UI Delay
          func prepareImpact()
          {
                    generatorLight.prepare()
                    generatorHeavy.prepare()
                    print("preparing to impact")
          }
          
          // Heavy Impact Feeback Snap
          func impactHeavy()
          {
                    generatorHeavy.impactOccurred()
                    generatorHeavy.impactOccurred()
                    generatorHeavy.impactOccurred()
                    print("heavy impact")
          }
          
          // Light Impact Feeback Snap
          func impactLight()
          {
                    generatorLight.impactOccurred()
                    print("light impact")
          }
          
          override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
          {
                    prepareImpact()
          }
          
          override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
          {
                    if let touch = touches.first, #available(iOS 9.0, *), traitCollection.forceTouchCapability == UIForceTouchCapability.available
                    {
                              let force = touch.force/touch.maximumPossibleForce

                              switch impactFinished
                              {
                                        // Pressing Down Triggering Heavy Snap Feedback
                                        case false :
                                                  
                                                  if force > pressureThreshold
                                                  {
                                                            self.impactFinished = true
                                                            self.impactHeavy()
                                                            self.prepareImpact()
                                                  }
                                        
                                        // Lifting Up Triggering Light Snap Feedback
                                        case true :
                                                  
                                                  if force < pressureThreshold
                                                  {
                                                            self.impactFinished = false
                                                            self.impactLight()
                                                            self.prepareImpact()
                                                  }
                              }
                    }
          }
          
//          @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer)
//          {
//                    updateLabel(text: "clear")
//                    countLabel.isHidden = true
//                    clearButton.isHidden = false
//                    cancelClear.isHidden = false
//                    print("clear")
//          }

          @IBAction func swipeLeft(_ sender: Any)
          {
                    countLabel.isHidden = true
                    clearButton.isHidden = false
                    cancelClear.isHidden = false
                    print("clear")
          }
          
          @IBAction func clearButton(_ sender: UIButton)
          {
                    updateLabel(text: 0)
                    countLabel.isHidden = false
                    clearButton.isHidden = true
                    cancelClear.isHidden = true
                    print("clear pressed")
          }
          
          @IBAction func cancelClear(_ sender: UIButton)
          {
                    countLabel.isHidden = false
                    clearButton.isHidden = true
                    cancelClear.isHidden = true
                    print("cancel clear")
          }
}












