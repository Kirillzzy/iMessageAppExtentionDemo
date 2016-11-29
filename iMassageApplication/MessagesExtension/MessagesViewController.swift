//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Kirill Averyanov on 28/11/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import UIKit
import Messages


class CompactViewController: UIViewController {
    var conversation : MSConversation?;
    @IBAction func beginningButtonPressed(_ sender: Any) {
        let controller: UIViewController
        controller = instantiateExpandedVC()
        let d = controller as! ExpandedViewController
        d.conversation = conversation
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }

    private func instantiateExpandedVC() -> UIViewController {
        guard let expandedVC = storyboard?.instantiateViewController(withIdentifier: "ExpandedVC") as? ExpandedViewController else {
            print("HERE")
            fatalError("Can't instantiate ExpandedViewController")
        }
    
        return expandedVC
    }
    
}

class ExpandedViewController: UIViewController {
    var conversation : MSConversation?;
    @IBOutlet weak var expressionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expressionLabel.text = ""
    }
    
    @IBAction func anyButtonPressed(_ sender: UIButton) {
        var value: String = String(sender.currentTitle!)
        if value == "÷"{
            value = "/"
        }
        if value == "×"{
            value = "*"
        }
        expressionLabel.text = expressionLabel.text! + value
    }
    
    @IBAction func equalsButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        expressionLabel.text = ""
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        if (expressionLabel.text?.characters.count)! > 0{
            expressionLabel.text?.remove(at: (expressionLabel.text!.endIndex))
        }
    }
    
}


class MessagesViewController: MSMessagesAppViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        presentVC(for: conversation, with: presentationStyle)
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    private func presentVC(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        let controller: UIViewController
        
        if presentationStyle == .compact {
            controller = instantiateCompactVC()
            let d = controller as! CompactViewController
            d.conversation = conversation
        } else {
            controller = instantiateExpandedVC()
            let d = controller as! ExpandedViewController
            d.conversation = conversation
        }
        
        addChildViewController(controller)
        
        // ...constraints and view setup...
        
        view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }
    
    private func instantiateCompactVC() -> UIViewController {
        guard let compactVC = storyboard?.instantiateViewController(withIdentifier: "CompactVC") as? CompactViewController else {
            fatalError("Can't instantiate CompactViewController")
        }
        
        return compactVC
    }
    
    private func instantiateExpandedVC() -> UIViewController {
        guard let expandedVC = storyboard?.instantiateViewController(withIdentifier: "ExpandedVC") as? ExpandedViewController else {
            fatalError("Can't instantiate ExpandedViewController")
        }
        
        return expandedVC
    }

    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        guard let conversation = activeConversation else {
            fatalError("Expected the active conversation")
        }
        
        presentVC(for: conversation, with: presentationStyle)
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {

    }
    
    

}