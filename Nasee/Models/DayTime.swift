//
//  DayTime.swift
//  Nasee
//
//  Created by Андрей Иванов on 13/04/2023.
//

import Foundation


struct DayTime {
    let morning = "Morning! ☀️"
    let afternoon = "Afternoon! 🌤️"
    let evening = "Evening! 🌙"
    let night = "Night! 😴"
    
    func getDayTime() -> String {
        let now = Date()
        let calendar = Calendar.current
        let morning = calendar.date(bySettingHour: 5, minute: 0, second: 0, of: now)!
        let afternoon = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: now)!
        let evening = calendar.date(bySettingHour: 17, minute: 0, second: 0, of: now)!
        let night = calendar.date(bySettingHour: 21, minute: 0, second: 0, of: now)!
        
        
        if now >= morning && now < afternoon {
            return self.morning
        } else if now >= afternoon && now < evening {
            return self.afternoon
        } else if now >= evening && now < night{
            return self.evening
        } else {
            return self.night
        }
    }
}
