//
//  ChatViewController.swift
//  MessageApp
//
//  Created by Nguyen Thanh Long on 02/11/2023.
//

import UIKit
import MessageKit

struct Message: MessageType{
    var sender: MessageKit.SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
}

struct Sender : SenderType {
    var photoURL: String
    var senderId: String
    
    var displayName: String
    
    
}

class ChatViewController: MessagesViewController {
    private var messages = [Message]()
    private let sender1 = Sender(photoURL: "", senderId: "1", displayName: "John Smith")
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messages.append(Message(sender: sender1, messageId: "1", sentDate: Date(), kind: .text("Hello world message")))
        
        messages.append(Message(sender: sender1, messageId: "1", sentDate: Date(), kind: .text("Hello world message 2")))
        // Do any additional setup after loading the view.
    }
    

}

extension ChatViewController : MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> MessageKit.SenderType {
        sender1
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}
