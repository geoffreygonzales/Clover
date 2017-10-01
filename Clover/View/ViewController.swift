//
//  ViewController.swift
//  Clover
//
//  Created by Geoffrey Gonzales on 10/1/17.
//  Copyright © 2017 Sunlight. All rights reserved.
//

import UIKit
import AudioToolbox
import CoreMotion

class ViewController : UIViewController
{
          @IBOutlet weak var countLabel: UILabel!
          @IBOutlet weak var clearButton: UIButton!
          @IBOutlet weak var cancelClear: UIButton!
          @IBOutlet var swipeLeft: UISwipeGestureRecognizer!
          @IBOutlet weak var normalCountButton: UIButton!
          
          // Universal Objects
          var count = 0
          var hapticAvaliable = false
          
          // 3D Touch Objects
          var impactFinished = false
          let generatorHeavy = UIImpactFeedbackGenerator(style: .heavy)
          let generatorLight = UIImpactFeedbackGenerator(style : .light)
          let pressureThreshold : CGFloat = 0.65
          
          override func viewDidLoad()
          {
                    super.viewDidLoad()
                    
                    if  #available(iOS 9.0, *),  traitCollection.forceTouchCapability == UIForceTouchCapability.available
                    {
                              normalCountButton.isHidden = true
                              hapticAvaliable = true
                              
                              print("haptic is avaliable")
                    }
                    
                    updateLabel(text: "hi")
          }
          
          // Passing In Value To Lable And Displaying It
          func updateLabel(text : Any)
          {
                    countLabel.text = "\(text)"
          }
          
          // Adding 1 To The Count And Displaying It
          func countOne()
          {
                    count = count + 1
                    updateLabel(text: count)
          }
          
          func minusOne()
          {
                    count = count - 1
                    updateLabel(text: count)
          }
          
          //  Single Vibration
          func buzz()
          {
                    if hapticAvaliable == false
                    {
                              AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                              print("buzz")
                    }
          }
          
          // Double Vibration
          func buzzBuzz()
          {
                    if hapticAvaliable == false
                    {
                              if normalCountButton.isHidden == false
                              {
                                        normalCountButton.isHidden = true
                                        print("normal count button is hidden")
                              }
                              else
                              {
                                        normalCountButton.isHidden = false
                                        print("normal count button is shown")
                              }
                              for _ in 1...2
                              {
                                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                                        usleep(350_000)
                              }
                              
                              print("buzz buzz ladies")
                    }
          }
          
          // 3d Touch For iPhone 6 And Newer
          // Preparing The Fedback Engine To Generate Feedback For Less UI Delay
          func prepareImpact()
          {
                    generatorLight.prepare()
                    generatorHeavy.prepare()
                    
                    print("preparing to impact")
          }
          
          // Heavy Impact Feeback
          func impactHeavy()
          {
                    generatorHeavy.impactOccurred()
                    print("heavy impact")
          }
          
          // Light Impact Feeback
          func impactLight()
          {
                    generatorLight.impactOccurred()
                    print("light impact")
          }
          
          // Alert Impact Feeback
          func impactClear()
          {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.error)
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
                                                            countOne()
                                                            
                                                            self.impactHeavy()
                                                            self.prepareImpact()
                                                            
                                                            self.impactFinished = true
                                                  }
                                        
                                        // Lifting Up Triggering Light Snap Feedback
                                        case true :
                                                  
                                                  if force < pressureThreshold
                                                  {
                                                            self.impactLight()
                                                            self.prepareImpact()
                                                            
                                                            self.impactFinished = false
                                                  }
                              }
                    }
          }
          
          @IBAction func normalCountButtonTapped(_ sender: UIButton)
          {
                    countOne()
                    buzz()
          }
          
          @IBAction func swipeLeft(_ sender: Any)
          {
                    if count != 0, hapticAvaliable == true
                    {
                              countLabel.isHidden = true
                              clearButton.isHidden = false
                              cancelClear.isHidden = false
                              swipeLeft.isEnabled = false
                              
                              impactClear()
                              
                              print("swipe left")
                    }
          }
          
          // Phone Is Shaken
          override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?)
          {
                    if count != 0
                    {
                              normalCountButton.isHidden = true
                              countLabel.isHidden = true
                              clearButton.isHidden = false
                              cancelClear.isHidden = false
                              swipeLeft.isEnabled = false
                              
                              impactClear()
                              
                              print("phone shook like fi + se")
                    }
          }
          
          @IBAction func clearButton(_ sender: UIButton)
          {
                    count = 0
                    updateLabel(text: count)
                    countLabel.isHidden = false
                    clearButton.isHidden = true
                    cancelClear.isHidden = true
                    swipeLeft.isEnabled = true
                    
                    impactClear()
                    buzzBuzz()
          
                    print("clear pressed")
          }
          
          @IBAction func cancelClear(_ sender: UIButton)
          {
                    if hapticAvaliable == false
                    {
                              normalCountButton.isHidden = false
                    }
                    countLabel.isHidden = false
                    clearButton.isHidden = true
                    cancelClear.isHidden = true
                    swipeLeft.isEnabled = true
                    
                    impactLight()

                    print("cancel clear")
          }
}












