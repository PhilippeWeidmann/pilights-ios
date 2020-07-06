//
//  DeviceManager.swift
//  bachelor
//
//  Created by Philippe Weidmann on 29.04.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import Foundation
import Alamofire

class DeviceManager {

    static let instance = DeviceManager()

    private let baseURL = "http://192.168.1.48:10068/"
    private let decoder = JSONDecoder()

    var rooms = Set<Room>()
    var devices = [Device]()

    private init() {

    }

    func getRooms() -> [Room] {
        return rooms.sorted()
    }
    
    public func refreshRooms(completion: @escaping () -> Void) {
        self.getRooms() { (roomsResponse) in
            if roomsResponse.status == .ok {
                if let rooms = roomsResponse.data {
                    self.devices.removeAll()
                    self.rooms = Set(rooms)
                    for room in rooms {
                        self.devices.append(contentsOf: room.devices)
                    }
                    for device in self.devices {
                        if device.type == .beacon {
                            FingerPrintManager.instance.knownBeaconMinors.append(device.value)
                        }
                    }
                }
            }
            completion()
        }
    }
    
    public func getRooms(completion: @escaping (ApiResponse<[Room]>) -> Void) {
        AF.request(
            baseURL + "rooms",
            method: .get
        )
            .responseDecodable(of: ApiResponse<[Room]>.self, decoder: decoder) { response in
                switch response.result {
                case .success(let deviceResponse):
                    completion(deviceResponse)
                case .failure(let error):
                    print(error)
                    completion(ApiResponse<[Room]>(status: .networkError, message: "error-network-offline"))
                }
        }
    }

    public func getDevice(deviceId: String, completion: @escaping (ApiResponse<Device>) -> Void) {
        AF.request(
            baseURL + "devices/\(deviceId)",
            method: .get
        )
            .responseDecodable(of: ApiResponse<Device>.self, decoder: decoder) { response in
                switch response.result {
                case .success(let deviceResponse):
                    completion(deviceResponse)
                case .failure(let error):
                    print(error)
                    completion(ApiResponse<Device>(status: .networkError, message: "error-network-offline"))
                }
        }
    }

    public func getDevices(completion: @escaping (ApiResponse<[Device]>) -> Void) {
        AF.request(
            baseURL + "devices",
            method: .get
        )
            .responseDecodable(of: ApiResponse<[Device]>.self, decoder: decoder) { response in
                switch response.result {
                case .success(let devicesResponse):
                    completion(devicesResponse)
                case .failure(let error):
                    print(error)
                    completion(ApiResponse<[Device]>(status: .networkError, message: "error-network-offline"))
                }
        }
    }

    public func updateRoomFor(device: Device, completion: @escaping (ApiResponse<Device>) -> Void) {
        AF.request(
            baseURL + "devices/\(device.id)",
            method: .post,
            parameters: [
                "roomId": device.roomId
            ]
        )
            .responseDecodable(of: ApiResponse<Device>.self, decoder: decoder) { response in
                switch response.result {
                case .success(let devicesResponse):
                    completion(devicesResponse)
                case .failure(let error):
                    print(error)
                    completion(ApiResponse<Device>(status: .networkError, message: "error-network-offline"))
                }
        }
    }
    
    public func updateNameForDevice(device: Device, completion: @escaping (ApiResponse<Device>) -> Void) {
        AF.request(
            baseURL + "devices/\(device.id)",
            method: .post,
            parameters: [
                "deviceName": device.name
            ]
        )
            .responseDecodable(of: ApiResponse<Device>.self, decoder: decoder) { response in
                switch response.result {
                case .success(let devicesResponse):
                    completion(devicesResponse)
                case .failure(let error):
                    print(error)
                    completion(ApiResponse<Device>(status: .networkError, message: "error-network-offline"))
                }
        }
    }
    
    public func updateDeviceState(device: Device, completion: @escaping (ApiResponse<Device>) -> Void) {
        AF.request(
            baseURL + "devices/\(device.id)",
            method: .post,
            parameters: [
                "value": device.value
            ]
        )
            .responseDecodable(of: ApiResponse<Device>.self, decoder: decoder) { response in
                switch response.result {
                case .success(let devicesResponse):
                    completion(devicesResponse)
                case .failure(let error):
                    print(error)
                    completion(ApiResponse<Device>(status: .networkError, message: "error-network-offline"))
                }
        }
    }
    
    
    public func createRoom(roomName: String, completion: @escaping (ApiResponse<Room>) -> Void) {
           AF.request(
               baseURL + "rooms",
               method: .post,
               parameters: [
                   "roomName": roomName
               ]
           )
               .responseDecodable(of: ApiResponse<Room>.self, decoder: decoder) { response in
                   switch response.result {
                   case .success(let devicesResponse):
                       completion(devicesResponse)
                   case .failure(let error):
                       print(error)
                       completion(ApiResponse<Room>(status: .networkError, message: "error-network-offline"))
                   }
           }
       }

}

