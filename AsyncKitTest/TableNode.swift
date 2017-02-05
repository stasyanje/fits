//
//  TableNode.swift
//  AsyncKitTest
//
//  Created by Admin on 04.02.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import AsyncDisplayKit

extension ASDimension {
    
    static func fraction(_ value: CGFloat) -> ASDimension {
        return ASDimension(unit: .fraction, value: value)
    }
    
    static func points(_ value: CGFloat) -> ASDimension {
        return ASDimension(unit: .points, value: value)
    }
}

class CellNode: ASCellNode {
    
    let topContentNode = ASDisplayNode()
    let textNodeTopLeft = ASTextNode()
    let textNodeTopRight = ASTextNode()
    let textNodeBottomLeft = ASTextNode()
    let textNodeBottomRight = ASTextNode()
    
    let imageButtonNode = ASButtonNode()
    let imageNode = ASNetworkImageNode()
    
    private var isImageStretched = false
    
    init(imageURL: URL?, topLeft: String, topRight: String, bottomRight: String, bottomLeft: String) {
        super.init()
        imageButtonNode.addTarget(self, action: #selector(onImageTapped), forControlEvents: .touchUpInside)
        imageNode.style.preferredSize = CGSize(width: 100, height: 100)
        imageNode.shouldCacheImage = false
        imageNode.setURL(imageURL, resetToDefault: true)
        textNodeTopLeft.attributedText = NSAttributedString(string: topLeft,
                                                            attributes: [ NSForegroundColorAttributeName: UIColor.black,
                                                                          NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17)])
        
        textNodeTopRight.attributedText = NSAttributedString(string: topRight,
                                                             attributes: [ NSForegroundColorAttributeName: UIColor.white,
                                                                           NSFontAttributeName: UIFont.systemFont(ofSize: 19)])
        textNodeBottomLeft.attributedText = NSAttributedString(string: bottomLeft,
                                                               attributes: [ NSForegroundColorAttributeName: UIColor.black,
                                                                             NSFontAttributeName: UIFont.italicSystemFont(ofSize: 17)])
        textNodeBottomRight.attributedText = NSAttributedString(string: bottomRight,
                                                                attributes: [ NSForegroundColorAttributeName: UIColor.white,
                                                                              NSFontAttributeName: UIFont.italicSystemFont(ofSize: 17)])
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        selectionStyle = .none
        topContentNode.cornerRadius = 5.0
        imageNode.clipsToBounds = true
        topContentNode.backgroundColor = UIColor.init(white: 244.0/255, alpha: 1.0)
        imageNode.contentMode = .scaleAspectFill
        imageNode.placeholderColor = .gray
        imageNode.clipsToBounds = true
        imageNode.cornerRadius = 3.0
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let imageFraction: CGFloat = isImageStretched ? 1.0 : 0.4
        textNodeTopLeft.style.flexBasis = .fraction(1.0 - imageFraction)
        textNodeTopLeft.style.flexShrink = 1.0
        let imageButtonSpec = ASOverlayLayoutSpec(child: imageNode,
                                                  overlay: imageButtonNode)
        let ratioSpec = ASRatioLayoutSpec(ratio: 1.0, child: imageButtonSpec)
        ratioSpec.style.flexBasis = .fraction(imageFraction)
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.spacing = 10
        stack.alignItems = .center
        stack.justifyContent = .start
        stack.verticalAlignment = .verticalAlignmentTop
        stack.children = isImageStretched ? [ratioSpec] : [ratioSpec, textNodeTopLeft]
        
        let verticalStack = ASStackLayoutSpec.vertical()
        verticalStack.spacing = 10
        verticalStack.children = isImageStretched ? [stack, textNodeTopLeft, textNodeBottomLeft] : [stack, textNodeBottomLeft]
        
        let innerInsetStack = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5),
                                                child: verticalStack)
        
        let backgroundSpec = ASBackgroundLayoutSpec(child: innerInsetStack,
                                                    background: topContentNode)
        


        let insetStack = ASInsetLayoutSpec()
        insetStack.insets = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
        insetStack.child = backgroundSpec
        
        return insetStack
    }
    
    @objc private func onImageTapped() {
        isImageStretched = !isImageStretched
        setNeedsLayout()
    }
    
}

