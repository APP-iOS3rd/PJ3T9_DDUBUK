//
//  Extension.swift
//  Ddubuk
//
//  Created by 조민식 on 2/16/24.
//

import SwiftUI

extension expandedView {
    public func font(_ font: Font) -> expandedView {
        var result = self
        
        result.font = font
        
        return result
    }
    public func lineLimit(_ lineLimit: Int) -> expandedView {
        var result = self
        
        result.lineLimit = lineLimit
        return result
    }
    
    public func foregroundColor(_ color: Color) -> expandedView {
        var result = self
        
        result.foregroundColor = color
        return result
    }
    
    public func expandButton(_ expandButton: TextSet) -> expandedView {
        var result = self
        
        result.expandButton = expandButton
        return result
    }
    
    public func collapseButton(_ collapseButton: TextSet) -> expandedView {
        var result = self
        
        result.collapseButton = collapseButton
        return result
    }
    
    public func expandAnimation(_ animation: Animation?) -> expandedView {
        var result = self
        
        result.animation = animation
        return result
    }
}

extension String {
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

public struct TextSet {
    var text: String
    var font: Font
    var color: Color

    public init(text: String, font: Font, color: Color) {
        self.text = text
        self.font = font
        self.color = color
    }
}

func fontToUIFont(font: Font) -> UIFont {
    if #available(iOS 14.0, *) {
        switch font {
        case .largeTitle:
            return UIFont.preferredFont(forTextStyle: .largeTitle)
        case .title:
            return UIFont.preferredFont(forTextStyle: .title1)
        case .title2:
            return UIFont.preferredFont(forTextStyle: .title2)
        case .title3:
            return UIFont.preferredFont(forTextStyle: .title3)
        case .headline:
            return UIFont.preferredFont(forTextStyle: .headline)
        case .subheadline:
            return UIFont.preferredFont(forTextStyle: .subheadline)
        case .callout:
            return UIFont.preferredFont(forTextStyle: .callout)
        case .caption:
            return UIFont.preferredFont(forTextStyle: .caption1)
        case .caption2:
            return UIFont.preferredFont(forTextStyle: .caption2)
        case .footnote:
            return UIFont.preferredFont(forTextStyle: .footnote)
        case .body:
            return UIFont.preferredFont(forTextStyle: .body)
        default:
            return UIFont.preferredFont(forTextStyle: .body)
        }
    } else {
        switch font {
        case .largeTitle:
            return UIFont.preferredFont(forTextStyle: .largeTitle)
        case .title:
            return UIFont.preferredFont(forTextStyle: .title1)
            //            case .title2:
            //                return UIFont.preferredFont(forTextStyle: .title2)
            //            case .title3:
            //                return UIFont.preferredFont(forTextStyle: .title3)
        case .headline:
            return UIFont.preferredFont(forTextStyle: .headline)
        case .subheadline:
            return UIFont.preferredFont(forTextStyle: .subheadline)
        case .callout:
            return UIFont.preferredFont(forTextStyle: .callout)
        case .caption:
            return UIFont.preferredFont(forTextStyle: .caption1)
            //            case .caption2:
            //                return UIFont.preferredFont(forTextStyle: .caption2)
        case .footnote:
            return UIFont.preferredFont(forTextStyle: .footnote)
        case .body:
            return UIFont.preferredFont(forTextStyle: .body)
        default:
            return UIFont.preferredFont(forTextStyle: .body)
        }
    }
}


