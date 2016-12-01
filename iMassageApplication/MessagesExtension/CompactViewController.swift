//
//  CompactViewController.swift
//  iMassageApplication
//
//  Created by Kirill Averyanov on 01/12/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import UIKit
import Messages

class CompactViewController: UIViewController {

    var conversation : MSConversation?;
    
    @IBAction func beginButtonPressed(_ sender: Any) {
        presentVC(for: conversation!)
    }
    
    
    private func presentVC(for conversation: MSConversation) {
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
            fatalError("Can't instantiate ExpandedViewController")
        }
        return expandedVC
    }
    

}
