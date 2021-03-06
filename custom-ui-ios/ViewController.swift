//
//  ViewController.swift
//  custom-ui-ios
//
//  Created by Anastasi Bakolias on 2018-01-17.
//  Copyright © 2018 Anastasi Bakolias. All rights reserved.
//

import UIKit
import Smooch

class ViewController: UIViewController, UITableViewDataSource, SKTConversationDelegate {
    @IBOutlet weak var conversationHistory: UITableView!
    @IBOutlet weak var messageInput: UITextField!
    
    @objc func endOfInput(){
        messageInput.resignFirstResponder()
        let text = messageInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.count > 0 {
            Smooch.conversation()?.sendMessage(SKTMessage(text: text))
        }
        messageInput.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageInput.addTarget(self, action: #selector(endOfInput), for: .editingDidEndOnExit)
        conversationHistory.tableFooterView = UIView()
        conversationHistory.dataSource = self
        conversationHistory.register(UITableViewCell.self, forCellReuseIdentifier: "MessageCell")
        if let messages = Smooch.conversation()?.messages {
            self.items = messages
        }
      
        //Smooch.conversation()?.delegate = self
        
        let delegate = self
        Smooch.update(delegate)
    }
    
    var items: [Any] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        
        let message = items[indexPath.row] as! SKTMessage
        let text = message.role == "business" ? "\(message.displayName!) says \(message.text!)" : message.text!

        cell.textLabel!.text = text
        return cell
    }
    
    func conversation(_ conversation: SKTConversation, willSend message: SKTMessage) -> SKTMessage {
        self.items.append(message)
        conversationHistory.reloadData()
        return message
    }
    
    func conversation(_ conversation: SKTConversation, didReceiveMessages messages: [Any]) {
        if let allMessages = Smooch.conversation()?.messages {
            self.items = allMessages
        }
        
        conversationHistory.reloadData()
    }
    
    func conversation(_ conversation: SKTConversation, shouldShowInAppNotificationFor message: SKTMessage) -> Bool {
          false
    }
    
    func conversation(_ conversation: SKTConversation, didReceive activity: SKTConversationActivity) {
        switch activity.type {
        case SKTConversationActivityTypeTypingStart:
            print("start typing")
            break
        case SKTConversationActivityTypeTypingStop:
            print("stop typing")
            break
        case SKTConversationActivityTypeConversationRead:
            print("conversation read")
            break
        default:
            print("default")
            break
        }
    }
    
}

