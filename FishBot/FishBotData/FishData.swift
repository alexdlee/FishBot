//
//  FishData.swift
//  FishBot
//
//  Created by Alex Lee on 2/12/24.
//

import Foundation

let categories = ["General Tips", "Obstacles", "Technique", "Other"]

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

struct UserDatabase {
    var allFishingSpots: Array<FishingSpot>
    var allFishingSessions: Array<FishingSession>
    var allNotes: Dictionary<Date, Note>
    var biggestFishCaught: Int
    var suggestions: Dictionary<String, String>
    var completed: Dictionary<String, String>
    
    init() {
        allFishingSpots = []
        allFishingSessions = []
        allNotes = [:]
        biggestFishCaught = 0
        suggestions = [:]
        completed = [:]
    }
                                
}



struct Note: Identifiable, Hashable, Codable {
    var id = UUID()
    var date: Date = Date()
    var content: String
    var category: String
    var locationName: String
    var number: Int
        
}

struct FishingSpot: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var pastNotes: Dictionary<Date, Note>
    var deletedNotes: Dictionary<Date, Note>
    var map: [[Int]]
    var key: Set<Dictionary<Int, String>>
    var numObstacles: Int
    var pastFishingSessions: Array<FishingSession>
    var averageTime: Duration
    var pastCatches: Array<Dictionary<Int, TimeInterval>>
    var numberObstacles: Int
    var latitude: Double
    var longitude: Double
    
    init() {
        name = ""
        pastNotes = [:]
        deletedNotes = [:]
        map = [[0]]
        key = []
        pastFishingSessions = []
        averageTime = .seconds(0)
        pastCatches = []
        numObstacles = 0
        latitude = 0.0
        longitude = 0.0
        numberObstacles = 0
    }
    
}

struct FishingSession: Identifiable, Hashable, Codable {
    var id = UUID()
    var number: Int
    var date: Date = Date()
    var location: String
    var fishCaught: Int
    var biggestFishLength: Int
    var timeFrame: Set<Date>
    var waterPurchased: Int
    var baitRemaining: Int
    var equipmentRecommendation: String
    var weather: String
    var fishingTechnique: String
    var isInProgress: Bool
    var notes: Dictionary<Date, Note>
    
    init() {
        number = 0
        location = ""
        fishCaught = 0
        biggestFishLength = 0
        timeFrame = []
        waterPurchased = 0
        baitRemaining = 0
        equipmentRecommendation = ""
        weather = "Clear"
        fishingTechnique = "None"
        isInProgress = true
        notes = [:]
    }
    
}

let editOptions = ["Date", "Fish Caught", "Biggest Fish", "Weather", "Technique"]
var creation = UserDatabase()
