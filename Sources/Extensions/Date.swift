//
//  NSDateExtension.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation

public extension Date {
    
    public var isPast: Bool {
        return self.compare(Date()) == .orderedAscending
    }
    
    public var isFuture: Bool {
        return !self.isPast
    }
    
    public init?(fromString: String, dateFormat: String = "yyyy/MM/dd HH:mm") {
        guard let date = DateFormatter(dateFormat: dateFormat).date(from: fromString),
            !fromString.isEmpty else { return nil }
        
        self.init(timeInterval: 0, since: date)
    }
    
    public func incrementDay(_ numberOfDays: Int = 1) -> Date {
        return Calendar.current
            .date(byAdding: .day,
                value: numberOfDays,
                to: self
            )!
    }
    
    public func incrementMinutes(_ numberOfMinutes: Int = 1) -> Date {
        return Calendar.current
            .date(byAdding: .minute,
                value: numberOfMinutes,
                to: self
            )!
    }
    
    public func incrementDayIfPast() -> Date {
        return self.isPast
            ? self.incrementDay() : self
    }
    
    public func timeToDecimal() -> Double {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute],
            from: self)
        let hour = components.hour
        let minutes = components.minute
        return Double(hour!) + (Double(minutes!) / 60.0)
    }
    
    public func toHijriString(
        _ unit: Set<Calendar.Component>? = nil,
        format: String? = nil,
        offSet: Int = 0) -> String {
            let calendar = Calendar(identifier: .islamicCivil)
            let flags = unit ?? [.year, .month, .day, .hour, .minute, .second]
            var date = self
            
            // Handle offset if applicable
            if offSet != 0 {
                date = calendar
                    .date(byAdding: .day,
                        value: offSet,
                        to: date
                    )!
            }
            
            let components = calendar.dateComponents(flags, from: date)
            
            let formatter = DateFormatter()
            if let f = format {
                formatter.dateFormat = f
            } else {
                formatter.dateStyle = .long
            }
            formatter.calendar = calendar
            
            return formatter.string(from: calendar.date(from: components)!)
    }
    
    public func toHijri(
        _ offSet: Int = 0) -> DateComponents {
            let calendar = Calendar(identifier: .islamicCivil)
            var date = self
            
            // Handle offset if applicable
            if offSet != 0 {
                date = calendar
                    .date(byAdding: .day,
                        value: offSet,
                        to: date
                    )!
            }
            
            return calendar.dateComponents([.year, .month, .day, .hour, .minute, .second],
                from: date)
    }
    
    public func countdown(_ date: Date)  -> (span: Double, remaining: Double, percent: Double) {
        // Calculate span time
        var timeSpan = date.timeToDecimal() - self.timeToDecimal()
        if timeSpan < 0 {
            timeSpan += 24
        }
        
        // Calculate remaining times
        var timeLeft = date.timeToDecimal() - Date().timeToDecimal()
        if timeLeft < 0 {
            timeLeft += 24
        }
        
        // Calculate percentage
        let percentComplete = 1.0 - (timeLeft / timeSpan)
        
        return (timeSpan, timeLeft, percentComplete)
    }
    
    /**
     Specifies if the date is beyond the time window.
     
     - parameter seconds:  Time window the date is considered valid.
     - parameter fromDate: Date to use as a reference.
     
     - returns: Has the time elapsed the time window.
     */
    public func hasElapsed(_ seconds: Int, fromDate: Date = Date()) -> Bool {
        return fromDate.timeIntervalSince(self).seconds > seconds
    }
    
}