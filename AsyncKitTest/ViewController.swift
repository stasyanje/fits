//
//  ViewController.swift
//  AsyncKitTest
//
//  Created by Admin on 01.02.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import AsyncDisplayKit
import LoremIpsum

extension ASTextNode {
    
    func setText(text: String) {
        guard let attributedText = self.attributedText else {
            let defaultAttributes: [String : Any] = [NSFontAttributeName : UIFont.systemFont(ofSize: 16),
                                                     NSForegroundColorAttributeName : UIColor.black]
            self.attributedText = NSAttributedString(string: text,
                                                     attributes: defaultAttributes)
            return
        }
        let wholeRange = NSRange(location: 0, length: attributedText.length)
        var attributes = [String : Any]()
        attributedText.enumerateAttributes(in: wholeRange, options: []) { attribute, _, _ in
            for (key, value) in attribute {
                attributes[key] = value
            }
        }
        self.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}

struct Item {
    
    var imageURL: String
    var topTitle: String
    var bottomTitle: String
}
class ViewController: ASViewController<ASDisplayNode> {
    
    var imageURLs: [String] = ["https://pp.vk.me/c637422/v637422170/2a5ef/zCFQOF8HayM.jpg",
                               "https://pp.vk.me/c636218/v636218360/3812a/1lXo4VmdZLE.jpg",
                               "https://pp.vk.me/c543105/v543105726/16235/N7xHdQ4rlFw.jpg",
                               "https://pp.vk.me/c418722/v418722504/8575/wSwQxKceOwg.jpg",
                               "https://cs541603.vk.me/c540105/v540105502/9ab47/DmbJ6RLc2cw.jpg",
                               "https://cs541603.vk.me/c540104/v540104577/506d3/SU0XG9_HCuE.jpg",
                               "https://pp.vk.me/c635106/v635106115/824b/42aahI0lgys.jpg",
                               "https://cs541603.vk.me/c635103/v635103881/a22e/bupItSCEVPc.jpg"]
    fileprivate var pageSize: Int = 50

    fileprivate var items = [Item]()
    
    var tableNode: ASTableNode
    var currentItemsCountNode: ASTextNode
    
    init() {
        let node = ASDisplayNode()
        
        let tableNode = ASTableNode(style: .plain)
        let countLabelNode = ASTextNode()
        countLabelNode.attributedText = NSAttributedString(string: "", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 30)])
        node.automaticallyManagesSubnodes = true
        
        node.layoutSpecBlock = { constrainedSize in
            tableNode.style.flexGrow = 1.0
            let labelInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 40, left: 10, bottom: 10, right: 10),
                                                   child: countLabelNode)
            let stackSpec = ASStackLayoutSpec.vertical()
            stackSpec.alignItems = .center
            stackSpec.justifyContent = .center
            stackSpec.children = [labelInsetSpec, tableNode]
            return stackSpec
        }
        self.tableNode = tableNode
        self.currentItemsCountNode = countLabelNode
        super.init(node: node)
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.tableNode = ASTableNode(style: .plain)
        self.currentItemsCountNode = ASTextNode()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableNode.view.tableFooterView = UIView()
        tableNode.view.separatorStyle = .none
        loadNextPage { }
    }
    
    fileprivate func loadNextPage(completion: @escaping () -> Void) {
        var items = [Item]()
        for _ in 0..<pageSize {
            let imageURL = imageURLs[Int(arc4random_uniform(UInt32(imageURLs.count)))]
            let item = Item(imageURL: imageURL,
                            topTitle: LoremIpsum.paragraph()!,
                            bottomTitle: LoremIpsum.paragraph())
            items.append(item)
        }
        DispatchQueue.main.async {
            self.insert(items: items)
            self.currentItemsCountNode.attributedText = NSAttributedString(string: "Current items count: \(self.items.count)",
                                                                           attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 30)])
            completion()
        }
    }
    
    fileprivate func insert(items: [Item]) {
        var indexPaths = [IndexPath]()
        for i in 0..<items.count {
            let indexPath = IndexPath(row: self.items.count + i, section: 0)
            indexPaths.append(indexPath)
        }
        self.items.append(contentsOf: items)
        tableNode.insertRows(at: indexPaths, with: .fade)
    }
}

extension ViewController: ASTableDataSource, ASTableDelegate {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let imageURL = imageURLs[Int(floor(Double(arc4random_uniform(UInt32(imageURLs.count)))))]
        let topLeft = LoremIpsum.paragraph()!
        let topRight = LoremIpsum.paragraph()!
        let bottomLeft = LoremIpsum.paragraph()!
        let bottomRight = LoremIpsum.paragraph()!
        
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
    
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        
        loadNextPage {
            context.completeBatchFetching(true)
        }
    }
}
