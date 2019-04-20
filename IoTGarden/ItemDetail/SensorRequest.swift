//
//  SensorRequest.swift
//  IoTGarden
//
//  Created by Apple on 2/8/19.
//

import APIKit
import Foundation
import Himotoki

struct SensorRequest: Request {
    
    typealias Response = Sensor
    
    var baseURL: URL {
        return URL(string: "http://alofirebase.herokuapp.com")!
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/data"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Sensor {
        return try Sensor(object: object)
    }
}

extension Sensor {
    
    init(object: Any) throws {
        
        guard let dictionary = object as? [String: Any],
            let rateDictionary = dictionary["rate"] as? [String: Any],
            let limit = rateDictionary["limit"] as? Int,
            let remaining = rateDictionary["remaining"] as? Int else {
                throw ResponseError.unexpectedObject(object)
        }
    }
}

extension SensorRequest {
    
    
//    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> ListingResponse {
//
//        let sensorValues = try decodeArray(object, rootKeyPath: ["values"]) as [SensorValue]
//        return  ListingResponse(sensorValues: sensorValues)
//    }
}

struct ListingResponse {
    
    let sensorValues: [SensorValue]
}
