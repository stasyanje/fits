//
//  ViewController.swift
//  AsyncKitTest
//
//  Created by Admin on 01.02.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import AsyncDisplayKit


class ViewController: ASViewController<ASDisplayNode> {
    
    var items: [String] = [" Neon looks like a cool framework! However, it wouldn't integrate with ASDK without a fair amount of work. Also, it seems like many of the features are already supported natively by ASLayoutSpec. A small number of the features are things that would fit nicely within the mental model / implementation framework of ASLayoutSpec / ASLayoutable",
                           "Adeste fideles læti triumphantes, Venite, venite in Bethlehem. Natum videte. Regem angelorum: Venite adoremus. Dominum",
                           "3 oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong Text",
                           "4 afdjkfdskflj aldkjsf aldkjsf lkdjsf kdjsflkdja lfkjas dlkfjsa dlkjfd kjsfljkas",
                           "5 asdfjsd kljfsdlfk jasdflk jadlfkjasdlkfjasdkl fjasdlkf jasdklfjasdkjlakdjflaldkjflkdjs",
                           "6 asdfjasdk lfadklsj fadklsjf asdkjf dkjsf lakdjfl kjasdflkjasdlfkjasdkfjalkdjsflakjsdflkjasdflkjasd",
                           "7 asdlfjkasdklfja lkjdflkajdsflkadjsf lakjsdfaldkjsfaskdjlasdljfaldfjaldjsflakdjsfkdjflsaldkjsasdklfjaosifasdljflkjaldsfjasdlfkjasdlkfjdslfkjasdflkjasdfasdkdlfjasdflkasdjflkadjs"]
    var imageURLs: [String] = ["https://pp.vk.me/c637422/v637422170/2a5ef/zCFQOF8HayM.jpg",
                               "https://pp.vk.me/c636218/v636218360/3812a/1lXo4VmdZLE.jpg",
                               "https://pp.vk.me/c543105/v543105726/16235/N7xHdQ4rlFw.jpg",
                               "https://pp.vk.me/c418722/v418722504/8575/wSwQxKceOwg.jpg",
                               "https://cs541603.vk.me/c540105/v540105502/9ab47/DmbJ6RLc2cw.jpg",
                               "https://cs541603.vk.me/c540104/v540104577/506d3/SU0XG9_HCuE.jpg",
                               "https://pp.vk.me/c635106/v635106115/824b/42aahI0lgys.jpg",
                               "https://cs541603.vk.me/c635103/v635103881/a22e/bupItSCEVPc.jpg"]
    
    var tableNode: ASTableNode
    
    init() {
        let node = ASDisplayNode()
        self.tableNode = ASTableNode(style: .plain)
        super.init(node: node)
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.tableNode = ASTableNode(style: .plain)
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        node.addSubnode(tableNode)
        tableNode.view.tableFooterView = UIView()
        tableNode.view.separatorStyle = .none
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableNode.frame = node.bounds
    }
}

extension ViewController: ASTableDataSource, ASTableDelegate {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let imageURL = imageURLs[Int(floor(Double(arc4random_uniform(UInt32(imageURLs.count)))))]
        let topLeft = items[Int(floor(Double(arc4random_uniform(UInt32(items.count)))))]
        let topRight = items[Int(floor(Double(arc4random_uniform(UInt32(items.count)))))]
        let bottomLeft = items[Int(floor(Double(arc4random_uniform(UInt32(items.count)))))]
        let bottomRight = items[Int(floor(Double(arc4random_uniform(UInt32(items.count)))))]
        
        return { () -> ASCellNode in
            return CellNode(imageURL: URL(string: imageURL),
                            topLeft: topLeft,
                            topRight: topRight,
                            bottomRight: bottomLeft,
                            bottomLeft: bottomRight)
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
    }
}
