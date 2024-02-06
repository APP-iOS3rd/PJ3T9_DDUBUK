//
//  TagLayout.swift
//  Ddubuk
//
//  Created by 조민식 on 2/6/24.
//

import SwiftUI

struct TagLayout: Layout {
    // Layout Properties
    var alignment: Alignment = .center
    // Both Horizontal & Vertical
    var spacing: CGFloat = 10
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? 0
        var height: CGFloat = 0
        let rows = generateRows(maxWidth, proposal, subviews)
        
        for (index, row) in rows.enumerated() {
            if index == (rows.count - 1) {
                height += row.maxHeight(proposal)
            } else {
                height += row.maxHeight(proposal) + spacing
            }
        }
        
        return .init(width: maxWidth, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var origin = bounds.origin
        let maxWidth = bounds.width
        let rows = generateRows(maxWidth, proposal, subviews)
        
        for row in rows {
            
            let leading: CGFloat = 0
            let trailing = maxWidth - (row.reduce(CGFloat.zero) { partialResult, view in
                let width = view.sizeThatFits(proposal).width
                
                if view == row.last {
                    return partialResult + width
                }
                return partialResult + width + spacing
            })
            let center = trailing / 2
            
            origin.x = (alignment == .leading ? leading : alignment == .trailing ? trailing : 0)
            for view in row {
                let viewSize = view.sizeThatFits(proposal)
                view.place(at: origin, proposal: proposal)
                
                origin.x += (viewSize.width + spacing)
            }
            
            origin.y += (row.maxHeight(proposal) + spacing)
        }
    }
    
    // Generating Rows based on Available Size
    func generateRows(_ maxWidth: CGFloat, _ proposal: ProposedViewSize, _ subviews: Subviews) -> [[LayoutSubviews.Element]] {
        var row: [LayoutSubviews.Element] = []
        var rows: [[LayoutSubviews.Element]] = []
        
        var origin = CGRect.zero.origin
        
        for view in subviews {
            let viewSize = view.sizeThatFits(proposal)
            
            if (origin.x + viewSize.width + spacing) > maxWidth {
                rows.append(row)
                row.removeAll()
                origin.x = 0
                row.append(view)
                origin.x += (viewSize.width + spacing)
            } else {
                row.append(view)
                origin.x += (viewSize.width + spacing)
            }
        }
        if !row.isEmpty {
            rows.append(row)
            row.removeAll()
        }
        return rows
    }
}

extension [LayoutSubviews.Element] {
    func maxHeight(_ proposal: ProposedViewSize) -> CGFloat {
        return self.compactMap { view in
            return view.sizeThatFits(proposal).height
        }.max() ?? 0
    }
}

#Preview {
    TagView()
}
