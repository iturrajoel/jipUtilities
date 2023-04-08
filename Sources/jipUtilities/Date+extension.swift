//
//  Date+extension.swift
//  ForGitHub
//
//  Created by Joel Iturra on 3/29/23.
//

import Foundation



extension Date {
    
    
    
    /// Returns the first day of the week
    ///
    /// For example, for New York if the date is Mar 29, 2023 07:54:00 -0500, it will return Mar 26, 2023 07:54:00 -0500
    public var firstDayOfWeek: Date {
        let weekday = Calendar.current.dateComponents([.weekday], from: self).weekday!
        return Calendar.current.date(byAdding: .day, value: -weekday + 1, to: self)!
    }
    
    
    
    /// Returns the first hour of the day
    ///
    /// For example, for New York if the date is Mar 29, 2023 07:54:00 -5000, it will return Mar 29, 2023 00:00:00 -0500
    public var begginingOfDay: Date {
        let components = Calendar.current.dateComponents([.day, .month, .year, .calendar, .era], from: self)
        return Calendar.current.date(from: components)!
    }
    
    
    
    /// Returns the first hour of the first day of the week
    ///
    /// For example, for New York if the date is Mar 29, 2023 07:54:00 0-0500, it will return Mar 26, 2023 00:00:00 -0500
    public var begginingOfThisWeek: Date {
        firstDayOfWeek.begginingOfDay
    }
    
    
    /// Returns the first hour of the first day of the next week
    ///
    /// For example, for New York if the date is Mar 29, 2023 07:54:00 -0500, it will return Apr 2, 2023 00:00:00 -0500
    public var beggningOfNextWeek: Date {
        Calendar.current.date(byAdding: .day, value: 7, to: self)!.begginingOfThisWeek
    }
    
    
    
}
