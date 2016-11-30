//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Kirill Averyanov on 28/11/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import UIKit
import Messages




class MathExpression {
    static private var expression: String = ""
    static func getExcpression() -> String {
        return expression
    }
    static func setExpression(_ newExpression: String) {
        expression = newExpression
    }
}


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
        expressionLabel.text = MathExpression.getExcpression()
    }
    
    @IBAction func anyButtonPressed(_ sender: UIButton) {
        var value: String = String(sender.currentTitle!)
        if value == "÷"{
            value = "/"
        }
        if value == "×"{
            value = "*"
        }
        setExpression(getExpression() + value)
    }
    
    @IBAction func equalsButtonPressed(_ sender: Any) {
        let session = conversation?.selectedMessage?.session ?? MSSession()
        let message = MSMessage(session: session)
        let layout = MSMessageTemplateLayout()
        layout.image = #imageLiteral(resourceName: "calc")
        layout.imageTitle = "iMessage Extension"
        layout.caption = "Hello world!"
        message.layout = layout
        message.summaryText = "Sent Hello World message"
        
        var components = URLComponents()
        let queryItem = URLQueryItem(name: "expression", value: getExpression())
        components.queryItems = [queryItem]
        message.url = components.url
        conversation?.insert(message)
    }

    
    @IBAction func clearButtonPressed(_ sender: Any) {
        setExpression("")
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        if getExpression().characters.count > 0{
            expressionLabel.text?.remove(at: (getExpression().endIndex))
        }
    }
    
    private func getExpression() -> String{
        return MathExpression.getExcpression()
    }
    
    private func setExpression(_ newExpression: String){
        expressionLabel.text = newExpression
        MathExpression.setExpression(newExpression)
    }
    
}


class MessagesViewController: MSMessagesAppViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        presentVC(for: conversation, with: presentationStyle)
    }
    
    override func didResignActive(with conversation: MSConversation) {
        
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        
    }
    
    override func didSelect(_ message: MSMessage, conversation: MSConversation) {
        //print("HERE IN DIDSELECT")
        /*guard let components = NSURLComponents(url: message.url!, resolvingAgainstBaseURL: false) else {
            fatalError("The message contains an invalid URL")
        }
        if let queryItems = components.queryItems {
            print((queryItems.first?.description)!)
            MathExpression.setExpression((queryItems.first?.value)!)
        }*/
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
    
    
    private func composeMessage() {
        let conversation = activeConversation
        let session = conversation?.selectedMessage?.session ?? MSSession()
        
        let layout = MSMessageTemplateLayout()
        layout.image = UIImage(named: "message-background.png")
        layout.imageTitle = "iMessage Extension"
        layout.caption = "Hello world!"
        layout.subcaption = "Sent by /(conversation?.localParticipantIdentifier)"
        
        let message = MSMessage(session: session)
        message.layout = layout
        message.summaryText = "Sent Hello World message"
        
        conversation?.insert(message)
    }
    
    

}
