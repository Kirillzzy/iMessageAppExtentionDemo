//
//  ExpandedViewController.swift
//  iMassageApplication
//
//  Created by Kirill Averyanov on 01/12/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import UIKit
import Messages

class ExpandedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var conversation : MSConversation?;
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messagesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if conversation?.selectedMessage != nil {
            MessagesClass.updateInfiormation(urls: (conversation?.selectedMessage?.url)!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messagesTableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        messagesTableView.reloadData()
        questionLabel.text = MessagesClass.question
    }
    
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        let text = messageTextField.text
        if text == ""{
            return
        }
        MessagesClass.messages.append(text!)
        let session = conversation?.selectedMessage?.session ?? MSSession()
        let message = MSMessage(session: session)
        let layout = MSMessageTemplateLayout()
        layout.image = #imageLiteral(resourceName: "calc")
        layout.imageTitle = "iMessage Extension"
        layout.caption = "Hello world!"
        message.layout = layout
        message.summaryText = "Sent Hello World message"
        
        message.url = MessagesClass.getUrls()
        conversation?.insert(message)
        
        presentVC(for: conversation!)
        
    }
    
    
    private func presentVC(for conversation: MSConversation) {
        let controller: UIViewController
        controller = instantiateCompactVC()
        let d = controller as! CompactViewController
        d.conversation = conversation
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessagesClass.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messagesTableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageTableViewCell
        cell.MessageLabel.text = MessagesClass.messages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        messagesTableView.deselectRow(at: indexPath, animated: true)
    }

}
