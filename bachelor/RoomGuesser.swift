//
//  RoomGuesser.swift
//  bachelor
//
//  Created by Philippe Weidmann on 29.03.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import Foundation

class RoomGuesser {

    let knownBeacons = [
        "0CF45574-5619-0B21-D31A-32739B7FE2D3",
        "0D51706A-D3A3-7ABF-B262-09DBDF07EEE8",
        "211F13D5-9B6E-6BEB-24DA-542DA1C11FFA",
        "390322CC-DBA3-E9D8-61F6-7AC618778400",
        "31ED25C5-A541-C128-CC63-219074E92124",
        "3EC4F64B-FFE8-B11A-4C0D-2CC094DC7400",
        "51164D00-179D-DC80-1E61-4E2FB3B372B8",
        "68ADEE52-2F0C-2723-2C12-FFD57966078A",
        "6DD3E427-EB1D-AC45-040E-40356FF14052",
        "77D5CE61-6C39-ABC0-43D6-FBEA9B44F72A",
        "8FF6E33F-94E3-9064-5123-125292FE50FD",
        "9041CEE3-632A-4D4D-70DA-5B226A24E568",
        "A8183C01-67BD-CD16-A077-CB26EBFB64BA",
        "AD1EAF71-A424-47E5-1CB5-E903A477664D",
        "ADCAD4ED-DE0E-728F-BAB6-4CBF39E9D062",
        "CA09F075-16CF-7673-128F-2F26365370D6",
        "E1E26493-959B-E3F4-2D9F-5520C42F26DD",
        "EBDF7BB3-756E-23C1-3CF5-8C85AF29387D"]

    let model = BachelorClassifier()

    static let instance = RoomGuesser()
    
    init() {
    }
    
    func guess(scannedValues: [UUID : Int]) -> String{
        let rssi1 = Double(scannedValues.first(where: { (key, value) -> Bool in return key.uuidString == knownBeacons[0] })?.value ?? 0)
        let rssi2 = Double(scannedValues.first(where: { (key, value) -> Bool in return key.uuidString == knownBeacons[1] })?.value ?? 0)
        let rssi3 = Double(scannedValues.first(where: { (key, value) -> Bool in return key.uuidString == knownBeacons[2] })?.value ?? 0)
        let rssi4 = Double(scannedValues.first(where: { (key, value) -> Bool in return key.uuidString == knownBeacons[3] })?.value ?? 0)
        let rssi5 = Double(scannedValues.first(where: { (key, value) -> Bool in return key.uuidString == knownBeacons[4] })?.value ?? 0)
        let rssi6 = Double(scannedValues.first(where: { (key, value) -> Bool in return key.uuidString == knownBeacons[5] })?.value ?? 0)
        let rssi7 = Double(scannedValues.first(where: { (key, value) -> Bool in return key.uuidString == knownBeacons[6] })?.value ?? 0)
        let rssi8 = Double(scannedValues.first(where: { (key, value) -> Bool in return key.uuidString == knownBeacons[7] })?.value ?? 0)
        let rssi9 = Double(scannedValues.first(where: { (key, value) -> Bool in return key.uuidString == knownBeacons[8] })?.value ?? 0)
        let rssi10 = Double(scannedValues.first(where: { (key, value) -> Bool in return key.uuidString == knownBeacons[9] })?.value ?? 0)
        let rssi11 = Double(scannedValues.first(where: { (key, value) -> Bool in return key.uuidString == knownBeacons[10] })?.value ?? 0)
        let rssi12 = Double(scannedValues.first(where: { (key, value) -> Bool in return key.uuidString == knownBeacons[11] })?.value ?? 0)
        let rssi13 = Double(scannedValues.first(where: { (key, value) -> Bool in return key.uuidString == knownBeacons[12] })?.value ?? 0)
        let rssi14 = Double(scannedValues.first(where: { (key, value) -> Bool in return key.uuidString == knownBeacons[13] })?.value ?? 0)
        let rssi15 = Double(scannedValues.first(where: { (key, value) -> Bool in return key.uuidString == knownBeacons[14] })?.value ?? 0)
        let rssi16 = Double(scannedValues.first(where: { (key, value) -> Bool in return key.uuidString == knownBeacons[15] })?.value ?? 0)
        let rssi17 = Double(scannedValues.first(where: { (key, value) -> Bool in return key.uuidString == knownBeacons[16] })?.value ?? 0)
        let rssi18 = Double(scannedValues.first(where: { (key, value) -> Bool in return key.uuidString == knownBeacons[17] })?.value ?? 0)

        print(rssi1)
        print(rssi2)
        print(rssi3)
        print(rssi4)
        print(rssi5)
        print(rssi6)
        print(rssi7)
        print(rssi8)
        print(rssi9)
        print(rssi10)
        print(rssi11)
        print(rssi12)
        print(rssi13)
        print(rssi14)
        print(rssi15)
        print(rssi16)
        print(rssi17)
        print(rssi18)
        
        do {
            let guessedRoom = try model.prediction(
                _0CF45574_5619_0B21_D31A_32739B7FE2D3: rssi1,
                _0D51706A_D3A3_7ABF_B262_09DBDF07EEE8: rssi2,
                _211F13D5_9B6E_6BEB_24DA_542DA1C11FFA: rssi3,
                _390322CC_DBA3_E9D8_61F6_7AC618778400: rssi4,
                _31ED25C5_A541_C128_CC63_219074E92124: rssi5,
                _3EC4F64B_FFE8_B11A_4C0D_2CC094DC7400: rssi6,
                _51164D00_179D_DC80_1E61_4E2FB3B372B8: rssi7,
                _68ADEE52_2F0C_2723_2C12_FFD57966078A: rssi8,
                _6DD3E427_EB1D_AC45_040E_40356FF14052: rssi9,
                _77D5CE61_6C39_ABC0_43D6_FBEA9B44F72A: rssi10,
                _8FF6E33F_94E3_9064_5123_125292FE50FD: rssi11,
                _9041CEE3_632A_4D4D_70DA_5B226A24E568: rssi12,
                A8183C01_67BD_CD16_A077_CB26EBFB64BA: rssi13,
                AD1EAF71_A424_47E5_1CB5_E903A477664D: rssi14,
                ADCAD4ED_DE0E_728F_BAB6_4CBF39E9D062: rssi15,
                CA09F075_16CF_7673_128F_2F26365370D6: rssi16,
                E1E26493_959B_E3F4_2D9F_5520C42F26DD: rssi17,
                EBDF7BB3_756E_23C1_3CF5_8C85AF29387D: rssi18)
            print(guessedRoom.roomProbability)

            return guessedRoom.room
        } catch {
            print(error)
            return "error"
        }
    }

}
