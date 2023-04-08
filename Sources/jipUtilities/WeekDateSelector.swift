//
//  WeeklyDateSelector.swift
//  ForGitHub
//
//  Created by Joel Iturra on 3/29/23.
//

import SwiftUI


/// Date selector that select the entire week when selecting any of the day in the desired week.
///
/// For example, if the user selectes Mar 21, 2023, the entire week from Mar 19 to Mar 25 will be selected automatically.
///
/// This depends in the current calendar (timezone and locale), however, it has not been tested in other time zones and locales.
@available(iOS 16.0, *)
public struct WeekDateSelector: View {
    
    @Binding private var selection: Set<DateComponents>
    private let range: Range<Date>
    
    
    
    public init(selection: Binding<Set<DateComponents>>, range: Range<Date> = Date.distantPast..<Date.distantFuture) {
        _selection = selection
        self.range = range
    }
    
    
    
    public var body: some View {
        MultiDatePicker("", selection: $selection, in: range)
            .onChange(of: selection) { [selection] newSelection in
                
                // First check if we need to recalculate the selection.
                guard newSelection.count > 0, selection != newSelection else { return }
                
                // If there is a new added date, use the first to calculate the new week
                if let firstAdded = newSelection.subtracting(selection).first {
                    
                    // Calculate the first hour of the week and the first hour of the next week
                    let day0 = Calendar.current.date(from: firstAdded)!.begginingOfThisWeek
                    let day7 = day0.beggningOfNextWeek
                    
                    var weekSelection = Set<DateComponents>()
                    var date = day0
                    
                    // Add the components for each day between day0 and day7 (day0..<day7)
                    while date.compare(day7) == .orderedAscending {
                        weekSelection.insert(Calendar.current.dateComponents([.calendar, .era, .day, .month, .year], from: date))
                        date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                    }
                    
                    self.selection = weekSelection
                    
                } else {
                    // otherwise, remove all the week, because it's a deselection
                    self.selection.removeAll()
                }
            }
    }
    
    
    
}
