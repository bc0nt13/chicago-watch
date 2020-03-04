//
//  IncidentPhoto.swift
//  ChicagoWatch
//
//  Created by Bruno Conti on 11/15/19.
//  Copyright © 2019 Bruno Conti. All rights reserved.
//

import Foundation
import UIKit

class IncidentPhoto{
    static func getCrimeImage(CrimeType type:String) -> UIImage{
        switch type.uppercased() {
        case "ARSON":
            return UIImage(named: "arson")!
        case "ASSAULT":
            return UIImage(named: "assualt")!
        case "BATTERY":
            return UIImage(named: "battery")!
        case "BURGLARY":
            return UIImage(named: "burglary")!
        case "CONCEALED CARRY LICENSE VIOLATION":
            return UIImage(named: "concealed-carry-violation")!
        case "CRIMINAL DAMAGE":
            return UIImage(named: "criminal-damage")!
        case "CRIMINAL TRESPASS":
            return UIImage(named: "criminal-trespass")!
        case "CRIM SEXUAL ASSAULT":
            return UIImage(named: "sexual-assault")!
        case "DECEPTIVE PRACTICE":
            return UIImage(named: "deceptive-practice")!
        case "DOMESTIC VIOLENCE":
            return UIImage(named: "domestic-violence")!
        case "GAMBLING":
            return UIImage(named: "gambling")!
        case "HOMICIDE":
            return UIImage(named: "homicide")!
        case "HUMAN TRAFFICKING":
            return UIImage(named: "human-trafficking")!
        case "INTERFERENCE WITH PUBLIC OFFICER":
            return UIImage(named: "interference-with-officer")!
        case "INTIMIDATION":
            return UIImage(named: "intimidation")!
        case "KIDNAPPING":
            return UIImage(named: "kidnapping")!
        case "LIQUOR LAW VIOLATION":
            return UIImage(named: "liquor-violation")!
        case "MOTOR VEHICLE THEFT":
            return UIImage(named: "motor-vehicle-theft")!
        case "NARCOTICS":
            return UIImage(named: "narcotics")!
        case "NON - CRIMINAL", "NON-CRIMINAL", "NON-CRIMINAL (SUBJECT SPECIFIED)":
            return UIImage(named: "non-criminal")!
        case "OBSCENITY":
            return UIImage(named: "obscenity")!
        case "OFFENSE INVOLVING CHILDREN":
            return UIImage(named: "offense-involving-children")!
        case "OTHER NARCOTIC VIOLATION":
            return UIImage(named: "other-narcotic-violation")!
        case "PROSTITUTION":
            return UIImage(named: "prostitution")!
        case "PUBLIC INDECENCY":
            return UIImage(named: "public-indecency")!
        case "PUBLIC PEACE VIOLATION":
            return UIImage(named: "peace-violation")!
        case "RITUALISM":
            return UIImage(named: "ritualism")!
        case "ROBBERY":
            return UIImage(named: "robbery")!
        case "SEX OFFENSE":
            return UIImage(named: "sex-offense")!
        case "STALKING":
            return UIImage(named: "stalking")!
        case "THEFT":
            return UIImage(named: "theft")!
        case "WEAPONS VIOLATION":
            return UIImage(named: "weapons-violation")!
        default:
            return UIImage(named: "other-offense")!
        }
    }

}
