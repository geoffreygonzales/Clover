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
import CoreData

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
          var onboardingCompleted = false
          
          // 3D Touch Objects
          var impactFinished = false
          let generatorHeavy = UIImpactFeedbackGenerator(style: .heavy)
          let generatorLight = UIImpactFeedbackGenerator(style : .light)
          let pressureThreshold : CGFloat = 0.40
          
          override func viewDidLoad()
          {
                    super.viewDidLoad()
                    
                    isOnboardingCompleted()
                    
                    if  #available(iOS 9.0, *),  traitCollection.forceTouchCapability == UIForceTouchCapability.available
                    {
                              normalCountButton.isHidden = true
                              hapticAvaliable = true
                              
                              print("haptic is avaliable")
                    }
                    
                    updateLabel(text: "0")
          }
          
          func isOnboardingCompleted()
          {
                    let fetchRequest : NSFetchRequest<Onboard> = Onboard.fetchRequest()
                    var onboardingResult = [Onboard]()
                    
//                    do
//                    {
//                              onboardingResult = try context.fetch(fetchRequest)
//                              let result = onboardingResult[0].hasBeenCompleted
//                              if result != nil {
//                              onboardingCompleted = result
//                              print("onboarding completed = \(result)")
//                              }
//                    }
//                    catch
//                    {
//                              print("unable to check if onboarding has been completed. error: \(error.localizedDescription)")
//                    }

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
          
          // Preparing The Haptic Generator When The Screen Is First Touched
          override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
          {
                    prepareImpact()
          }
          
          // Getting The Value Of The Force That The Screen Is Pressed
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
          
          // Button For Counting On Devices Without Haptic Feedback
          @IBAction func normalCountButtonTapped(_ sender: UIButton)
          {
                    countOne()
                    buzz()
          }
          
          // Shows Clear Button And Cancel Button
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
                    if count != 0, hapticAvaliable == false
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
          
          // Clear The Counter
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
          
                    print("cleared")
          }
          
          // Cancel Clear UI Going Back To Counting UI
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












