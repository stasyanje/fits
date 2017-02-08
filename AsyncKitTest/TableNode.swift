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

private let backColor = UIColor(white: 244.0/255, alpha: 1.0)
private let holderColor = UIColor(white: 220.0/255, alpha: 1.0)

class CellNode: ASCellNode {
    
    let topContentNode = ASDisplayNode()
    let textNodeTopLeft = ASTextNode()
    let textNodeBottomLeft = ASTextNode()
    
    let imageButtonNode = ASButtonNode()
    let imageNode = ASNetworkImageNode()
    
    private var isImageStretched = false
    
    init(imageURL: URL?, topTitle: String, bottomTitle: String) {
        super.init()
        imageButtonNode.addTarget(self, action: #selector(onImageTapped), forControlEvents: .touchUpInside)
        imageNode.style.preferredSize = CGSize(width: 100, height: 100)
        var currentTextNode = 0
        let titles = [topTitle, bottomTitle]
        [textNodeTopLeft,
         textNodeBottomLeft,
        ].forEach {
            self.configureTextNode(textNode: $0, text: titles[currentTextNode])
            currentTextNode += 1
        }
        topContentNode.backgroundColor = backColor
        imageNode.setURL(imageURL, resetToDefault: true)
        automaticallyManagesSubnodes = true
        selectionStyle = .none
        topContentNode.cornerRadius = 5.0
        imageNode.contentMode = .scaleAspectFill
        imageNode.placeholderColor = holderColor
        imageNode.clipsToBounds = true
        imageNode.cornerRadius = 3.0
        topContentNode.placeholderFadeDuration = 0.2
        imageNode.placeholderFadeDuration = 0.2
        textNodeTopLeft.placeholderFadeDuration = 0.2
        textNodeBottomLeft.placeholderFadeDuration = 0.2
    }
    
    private func configureTextNode(textNode: ASTextNode, text: String) {
        textNode.placeholderColor = holderColor
        textNode.attributedText = NSAttributedString(string: text,
                                                     attributes: [ NSForegroundColorAttributeName: UIColor.black,
                                                                   NSFontAttributeName: UIFont.systemFont(ofSize: 19)])
        textNode.backgroundColor = backColor
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
        insetStack.insets = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        insetStack.child = backgroundSpec
        
        return insetStack
    }
    
    @objc private func onImageTapped() {
        isImageStretched = !isImageStretched
        setNeedsLayout()
    }
    
}

