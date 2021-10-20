//
//  TennisEventType.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 17/10/2021.
//

import Foundation

enum TennisEventType: String, Codable {
    case FirstServe = "FIRST_SERVE"
    case SecondServe = "SECOND_SERVE"
    case Let = "LET"
    case Fault = "FAULT"
    case TeamOnePoint = "TEAM_ONE_POINT"
    case TeamTwoPoint = "TEAM_TWO_POINT"
}
