//
//  SwiftUIView.swift
//  
//
//  Created by Joel Iturra on 4/17/23.
//

import SwiftUI


/// A grid that has variable columns in each row, allowing to fit as many as views it's possible in each row.
struct SmartVerticalGrid: Layout {
    
    
    
    // MARK: - Private constants
    
    
    private let horizontalAlignment: HorizontalAlignment
    private let verticalAlignment: VerticalAlignment
    private let horizontalSpacing: CGFloat
    private let verticalSpacing: CGFloat
    

    
    // MARK: - Private struct
    
    
    
    private struct Row {
        var size: CGSize
        var count: Int
    }

    
    
    // MARK: - Init
    
    
    
    /// - parameter horizontalAlignment: Rows horizontal alignment with respect to the view
    /// - parameter verticalAlignment: View vertical alignment with respect to its row
    /// - parameter horizontalSpacing: The horizontal space between each view
    /// - parameter verticalSpacing: The vertical space between each row
    public init(horizontalAlignment: HorizontalAlignment = .leading,
         verticalAlignment: VerticalAlignment = .top,
         horizontalSpacing: CGFloat = 2,
         verticalSpacing: CGFloat = 2) {
        
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }
    
    
    
    // MARK: - Layout required methods
    
    
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        
        guard !subviews.isEmpty else { return .zero }
        
        let subviewSizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let rows = calculateGridRows(sizes: subviewSizes, proposal: proposal)
        
        // The view width will be the minimum between the maximum width available and the maximum rows width.
        let width = min(proposal.width ?? 0, rows.map({ $0.size.width }).max() ?? 0)
        
        // The view height is whatever is needed for all the views to fit.
        let height = rows.map({ $0.size.height }).reduce(0, +) + verticalSpacing * CGFloat(rows.count - 1)
        
        return CGSize(width: width, height: height)
    }
    
    
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        
        guard !subviews.isEmpty else { return }
        
        let subviewSizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let rows = calculateGridRows(sizes: subviewSizes, proposal: proposal)
        
        // General note: remember that the bounds could start in a different point than (0,0), so always look for the bounds values.
        
        var pointY = bounds.minY
        var index = 0
        
        // For each row
        for rowIndex in 0..<rows.count {
        
            // Calculate the pointX (origin.x) for each one of the 3 supported alignments
            // By default is .center
            var pointX: CGFloat!
            switch horizontalAlignment {
                case .leading:
                    pointX = bounds.minX
                case .trailing:
                    pointX = bounds.minX + bounds.width - rows[rowIndex].size.width
                case .center: // Just to clarify that is the default
                    fallthrough
                default:
                    pointX = bounds.minX + (bounds.width - rows[rowIndex].size.width) / 2
            }
            
            // For each view in the row
            for _ in 0..<rows[rowIndex].count {
                
                // Calculate the pointY (origin.y) for each view in the row.
                // By default is .center
                var viewPointY: CGFloat!
                switch verticalAlignment {
                    case .top:
                        viewPointY = pointY
                    case .bottom:
                        viewPointY = pointY + rows[rowIndex].size.height - subviewSizes[index].height
                    case .center: // Just to clarify that is the default
                        fallthrough
                    default:
                        viewPointY = pointY + (rows[rowIndex].size.height - subviewSizes[index].height) / 2
                }
                
                // NOTE: the view is anchored to the top leading point. That's why the pointX and viewPointY are calculated
                // in that position.
                subviews[index].place(at: CGPoint(x: pointX, y: viewPointY),
                                      anchor: .topLeading,
                                      proposal: ProposedViewSize(subviewSizes[index]))
                
                pointX += horizontalSpacing + subviewSizes[index].width
                index += 1
            }
            
            pointY += verticalSpacing + rows[rowIndex].size.height
        }
        
    }
    
    
    
    // MARK: - Private methods
    
    
    
    /// Calculate how many items fit in each row, returning also the row required size.
    ///
    /// - returns: An array containing the Row data (size and count).
    private func calculateGridRows(sizes: [CGSize], proposal: ProposedViewSize) -> [Row] {
        
        var rows = [Row]()
        var itemsCurrentRow = 0
        var currentRowWidth = 0.0
        var maxHeight = 0.0
        
        for size in sizes {
            if itemsCurrentRow == 0 {
                // If the row is empty, always add the view, whatever size it is
                itemsCurrentRow = 1
                currentRowWidth = size.width
                maxHeight = size.height
            } else if currentRowWidth + horizontalSpacing + size.width <= proposal.width ?? 0 {
                // If the current view fits, add it to the current row stats
                itemsCurrentRow += 1
                currentRowWidth += horizontalSpacing + size.width
                maxHeight = max(maxHeight, size.height)
            } else {
                // If the current view doesn't fit, add it in the next row
                rows.append(Row(size: CGSize(width: currentRowWidth, height: maxHeight), count: itemsCurrentRow))
                itemsCurrentRow = 1
                currentRowWidth = size.width
                maxHeight = size.height
            }
        } // for
        
        // Just in case any view was missing
        if itemsCurrentRow > 0 {
            rows.append(Row(size: CGSize(width: currentRowWidth, height: maxHeight), count: itemsCurrentRow))
        }
        
        return rows
    }
    
    
    
    
    
}


