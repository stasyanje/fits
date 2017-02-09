//
//  ViewController.swift
//  AsyncKitTest
//
//  Created by Admin on 01.02.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import AsyncDisplayKit
import LoremIpsum

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
    fileprivate var pageSize: Int = 25

    fileprivate var items = [Item]() {
        didSet {
            currentItemsCountNode.attributedText = NSAttributedString(string: "Current items count: \(self.items.count)",
                                                                        attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18)])
        }
    }
    
    var tableNode: ASTableNode
    var currentItemsCountNode: ASTextNode
    
    init() {
        
        let tableNode = ASTableNode(style: .plain)
        let countLabelNode = ASTextNode()
        
        let node = ASDisplayNode()
        node.automaticallyManagesSubnodes = true
        node.layoutSpecBlock = { constrainedSize in
            tableNode.style.flexGrow = 1.0
            tableNode.style.flexShrink = 1.0
            tableNode.style.maxLayoutSize = ASLayoutSize(width: .fraction(1.0),
                                                         height: .fraction(0.8))
            
            let centerSpec = ASCenterLayoutSpec(centeringOptions: .XY,
                                                sizingOptions: .minimumXY,
                                                child: countLabelNode)

            var inset: UIEdgeInsets = .zero
            inset.top += 15
            let insetSpec = ASInsetLayoutSpec(insets: inset, child: centerSpec)
            insetSpec.style.flexGrow = 1.0
            insetSpec.style.flexShrink = 1.0
            
            let stackSpec = ASStackLayoutSpec.vertical()
            stackSpec.alignItems = .center
            stackSpec.justifyContent = .center
            stackSpec.children = [insetSpec, tableNode]
            return stackSpec
        }
        self.tableNode = tableNode
        self.currentItemsCountNode = countLabelNode
        super.init(node: node)
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
        tableNode.view.leadingScreensForBatching = 20.0
        tableNode.dataSource = self
        tableNode.delegate = self
        loadNextPage { }
    }
    
    fileprivate func loadNextPage(completion: @escaping () -> Void) {
        var items = [Item]()
        for _ in 0..<pageSize {
            let imageURL = imageURLs[Int(arc4random_uniform(UInt32(imageURLs.count)))]
            let item = Item(imageURL: imageURL,
                            topTitle: LoremIpsum.sentences(withNumber: 2) ,
                            bottomTitle: LoremIpsum.sentences(withNumber: 2))
            items.append(item)
        }
        DispatchQueue.main.async {
            self.insert(items: items) {
                completion()
            }
        }
    }
    
    fileprivate func insert(items: [Item], completion: @escaping () -> Void) {
        var indexPaths = [IndexPath]()
        for i in 0..<items.count {
            let indexPath = IndexPath(row: self.items.count + i, section: 0)
            indexPaths.append(indexPath)
        }
        tableNode.performBatch(animated: false, updates: { [weak self] in
            self?.items.append(contentsOf: items)
            self?.tableNode.insertRows(at: indexPaths, with: .none)
        }) { _ in
            completion()
        }
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
        let item = items[indexPath.row]
        
        return { () -> ASCellNode in
            return CellNode(imageURL: URL(string: item.imageURL),
                            topTitle: item.topTitle,
                            bottomTitle: item.bottomTitle)
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        
        loadNextPage {
            context.completeBatchFetching(true)
        }
    }
}
