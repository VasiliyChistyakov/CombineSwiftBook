//
//  ViewController.swift
//  CombineSwiftBook
//
//  Created by Василий  on 24.12.2021.
//

import UIKit
import Combine

struct BlogPost {
    let title: String
    let url: URL
}

extension Notification.Name {
    
    static let newBlogPost = Notification.Name("NewBlogPost")
}

class ViewController: UIViewController {
    
    @Published var canMakePost: Bool = false
    
    private var switchSubscriber: AnyCancellable?
    
    @IBOutlet weak var acceptTermsSwich: UISwitch!
    @IBOutlet weak var makePostButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchSubscriber =  $canMakePost.receive(on: DispatchQueue.main).assign(to: \.isEnabled, on: makePostButton)
        
        setupCobine()
    }
    
    private func setupCobine() {
        let blogPostPubisher = NotificationCenter.Publisher(center: .default, name: .newBlogPost, object: nil).map({ (notfifcation) -> String? in
            return (notfifcation.object as? BlogPost)?.title ?? ""
        })
        let postLabelSubscriber = Subscribers.Assign(object: label, keyPath: \.text)
        
        blogPostPubisher.subscribe(postLabelSubscriber)
    }
    
    @IBAction func toggleSwitch(_ sender: UISwitch) {
        canMakePost = sender.isOn
    }
    
    @IBAction func makePostButtonTapped(_ sender: Any) {
        let blogPost = BlogPost(title: "New post \(Date())", url: URL(string: "fdd")!)
        NotificationCenter.default.post(name: .newBlogPost, object: blogPost)
        print("lust post is \(label.text!)")
    }
}

