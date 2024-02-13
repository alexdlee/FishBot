//
//  LakeView.swift
//  FishBot
//
//  Created by Alex Lee on 2/12/24.
//

import SwiftUI
import MapKit

struct LakeView: View {
    
    @State private var askNew = false
    @State private var userDatabase: UserDatabase = creation
    @State private var nameError = false
    @State private var nameText = ""
    @State private var deleteMode = false
    @State var lake: FishingSpot
    
    var body: some View {
        
        NavigationView {
            VStack {
                Text(lake.name)
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                HStack{
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .foregroundColor(.green)
                        .frame(width: 25, height: 25)
                        .onTapGesture{
                            changeFishingSessions(add: true)
                            deleteMode = false
                        }
                    
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .foregroundColor(.red)
                        .frame(width: 25, height: 25)
                        .onTapGesture {
                            changeFishingSessions(add: false)
                            deleteMode = true
                            askNew = true
                        }
                    
                } .padding(.bottom, 40)
                   
                if askNew {
                    VStack {
                        ZStack {
                            Rectangle()
                                .fill(Color(red: 0.9, green: 0.9, blue: 0.9))
                                .frame(width: 355, height: 300)
                                .cornerRadius(8)
                            Text("Enter the fishing session number you would like to delete:")
                                .padding(.bottom, 200)
                                .multilineTextAlignment(.center)
                                .frame(width: 300)
                            TextField("Name", text: $nameText)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                                .frame(width: 300)
                                .background(Color.clear)
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 2))
                                .padding(.bottom, 80)
                                
                            Button {
                                if deleteMode {
                                    changeFishingSessions(add: false)
                                } else {
                                    changeFishingSessions(add: true)
                                }
                            } label: {
                                Text("Delete Session")
                            }
                                
                            .frame(width: 150, height: 45)
                            .background(.blue)
                            .clipShape(.capsule)
                            .foregroundColor(.white)
                            .padding(.top, 40)
                                
                            if nameError {
                                Text("That session number doesn't exist! Try again!")
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 320)
                                    .padding(.top, 100)
                                    
                            }
                                
                            Button {
                                askNew = false
                            } label: {
                                Text("Close")
                            }
                            .frame(width: 100, height: 30)
                            .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.black, lineWidth: 1)) // Adjust the border width as needed
                            .foregroundColor(.black)
                            .padding(.top, 200)
                         
                        }
                            
                        Spacer()
                    }
                }
                
                List(lake.pastFishingSessions) { session in
                    NavigationLink(destination: SessionView(sessionNum: session, spot: lake)) {
                        Text("Session #\(session.number)")
                    }
                }
                
                List {
                    NavigationLink(destination: NotesView(spot: lake)) {
                        VStack {
                            HStack {
                                Text("Notes about " + lake.name)
                                    .font(.system(size: 20))
                                
                                Spacer()
                            }
                        }
                    }
                    
                    NavigationLink(destination: MapView(spot: lake)) {
                        VStack {
                            HStack {
                                Text("Your Map of " + lake.name)
                                    .font(.system(size: 20))
                                
                                Spacer()
                            }
                        }
                    }
                    NavigationLink(destination: CatchTimeTrackerView(spot: lake)) {
                        VStack {
                            HStack {
                                Text("Catch Time Tracker")
                                    .font(.system(size: 20))
                                
                                Spacer()
                            }
                        }
                    }
                    
                    NavigationLink(destination: BaitManagerView(spot: lake)) {
                        VStack {
                            HStack {
                                Text("Bait Manager")
                                    .font(.system(size: 20))
                                
                                Spacer()
                            }
                        }
                    }
                    
                    NavigationLink(destination:EquipmentManagerView(spot:lake)) {
                        VStack {
                            HStack{
                                Text("Equipment Manager")
                                    .font(.system(size:20))
                            }
                        }
                    }
                }
                    
            }
                
        }
        
    }
    
    func changeFishingSessions(add: Bool) {
        nameError = false
        if add {
            var newSession = FishingSession()
            newSession.number = lake.pastFishingSessions.count+1
            lake.pastFishingSessions.append(newSession)
        } else {
            var isFound = false
            for session in lake.pastFishingSessions {
                if session.number == Int(nameText) {
                    isFound = true
                }
            }
            if isFound && !nameText.isEmpty{
                lake.pastFishingSessions.removeAll { Int(nameText) == $0.number}
                nameError = false
            } else if nameText.isEmpty && !isFound {
                nameError = false
            } else {
                return
            }
        }
    }
}

struct NotesView: View {
    @State private var noteText: String = ""
    @State private var noteType: String = ""
    @State private var nameError: Bool = false
    @State private var askNew: Bool = false
    @State private var nameText: String = ""
    @State var spot: FishingSpot
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Notes on " + spot.name)
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                
                Text("What's on your mind today?")
                    .frame(width: 300)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                TextField("Note Entry", text: $noteText)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 40)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .frame(width: 350, height: 30)
                HStack {
                    Text("Category:")
                    Picker("Category:", selection: $noteType) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }
                }
                
                Button {
                    recordNote()
                } label: {
                    Text("Submit")
                }
                .frame(width: 150, height: 45)
                .background(.blue)
                .clipShape(.capsule)
                .foregroundColor(.white)
                .padding(.top, 40)
                
                Spacer()
                
                Image(systemName: "minus.circle.fill")
                    .resizable()
                    .foregroundColor(.red)
                    .frame(width: 25, height: 25)
                    .onTapGesture {
                        deleteNotes()
                        askNew = true
                            
                } .padding(.top, 40)
                           
                if askNew {
                    VStack {
                        ZStack {
                            Rectangle()
                                .fill(Color(red: 0.9, green: 0.9, blue: 0.9))
                                .frame(width: 355, height: 300)
                                .cornerRadius(8)
                            Text("Enter the fishing note number you would like to delete:")
                                .padding(.bottom, 200)
                                .multilineTextAlignment(.center)
                                .frame(width: 300)
                            TextField("Name", text: $nameText)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                                .frame(width: 300)
                                .background(Color.clear)
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 2))
                                .padding(.bottom, 80)
                                        
                            Button {
                                deleteNotes()
                            } label: {
                                Text("Delete Note")
                            }
                                        
                            .frame(width: 150, height: 45)
                            .background(.blue)
                            .clipShape(.capsule)
                            .foregroundColor(.white)
                            .padding(.top, 40)
                                        
                            if nameError {
                                Text("That note doesn't exist! Try again!")
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 320)
                                    .padding(.top, 100)
                                            
                            }
                                        
                            Button {
                                askNew = false
                            } label: {
                                Text("Close")
                            }
                            .frame(width: 100, height: 30)
                            .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.black, lineWidth: 1)) // Adjust the border width as needed
                            .foregroundColor(.black)
                            .padding(.top, 200)
                                 
                        }
                                    
                        Spacer()
                    }
                }
                List(Array(spot.pastNotes), id: \.value) { pastNote in
                    NavigationLink(destination: DetailedNoteView(note: pastNote.value)) {
                        HStack {
                            Text(dateFormatter.string(from: pastNote.key))
                        }
                        
                    }
                }
            }
        } .navigationBarBackButtonHidden(true)
    }
    func recordNote() {
        var note = Note(content: noteText, category: noteType, locationName: spot.name, number: spot.pastNotes.count+1)
        spot.pastNotes[note.date] = note
    }
    
    func deleteNotes() {
        nameError = false
        var isFound = false
        for value in spot.pastNotes.values {
            if value.number == Int(nameText) {
                isFound = true
            }
        }
        if isFound && !nameText.isEmpty {
            for (key,value) in spot.pastNotes {
                if value.number == Int(nameText) {
                    spot.pastNotes.removeValue(forKey:key)
                    spot.deletedNotes[key] = value
                }
            }
            nameError = false
                
        } else if nameText.isEmpty && !isFound {
            nameError = false
        } else {
            return
        }
    }
}

struct DetailedNoteView: View {
    @State var note: Note
    var body: some View {
        NavigationView {
            VStack {
                Text("Your Note")
                    .fontWeight(.bold)
                    .font(.system(size:20))
                    .padding(.top, 20)
                Text(dateFormatter.string(from: note.date))
                    .padding(.top, 20)
                Text(note.category)
                    .padding(.top, 20)
                Text(note.content)
                    .padding(.top, 20)
                Spacer()
            }
            
        } .navigationBarBackButtonHidden(true)
    }
}

struct MapView: View {
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State var spot: FishingSpot
    @State private var submitted: Bool = false
    @State private var numObstacles: String = ""
    
    var convertedLatitude: Double {
        Double(latitude) ?? 0
    }
    
    var convertedLongitude: Double {
        Double(longitude) ?? 0
    }
    
    struct Location: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
        let title: String
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                Text("Your map of " + spot.name)
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                
                Text("Enter the lake's approximate latitude:")
                    .frame(width: 325)
                    .padding(.top, 30)
                
                TextField("Latitude", text: $latitude)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 40)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .frame(width: 350, height: 30)
                    .padding(.top, 20)
                
                
                Text("Enter the lake's approximate longitude:")
                    .frame(width: 325)
                    .padding(.top, 20)
                
                TextField("Latitude", text: $longitude)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 40)
                    .background(Color.gray.opacity(0.1))
                    .frame(width: 350, height: 30)
                    .cornerRadius(8)
                    .padding(.top, 20)
                
                Button {
                    recordCoordinate()
                } label: {
                    Text("Submit")
                }
                .frame(width: 150, height: 45)
                .background(.blue)
                .clipShape(.capsule)
                .foregroundColor(.white)
                .padding(.top, 40)
                
                if submitted {
                    
                    HStack {
                        Text("How many obstacles are you aware of?")
                        Picker("Obstacles:", selection: $numObstacles) {
                            ForEach(1..<10, id: \.self) { number in
                                Text("\(number)")
                            }
                        }
                    }
                    
                    Button {
                        spot.numberObstacles = Int(numObstacles) ?? 0
                    } label: {
                        Text("Submit")
                    }
                    .frame(width: 150, height: 45)
                    .background(.blue)
                    .clipShape(.capsule)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                    
                    Text(spot.name)
                        .padding(.top, 20)
                    Map(coordinateRegion: .constant(MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude),
                        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                    ))) .frame(width: 350, height: 300)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: 1) // Adjust the border width as needed
                        )
                }

                Spacer()
            }
        } .navigationBarBackButtonHidden(true)
        
    }
    func recordCoordinate() {
        spot.latitude = convertedLatitude
        spot.longitude = convertedLongitude
        submitted = true
    }
    
}

struct CatchTimeTrackerView: View {
    @State var spot: FishingSpot
    @State private var elapsedTime: TimeInterval = 0.0
    @State private var timer: Timer?
    @State private var timerRunning: Bool = false
    @State private var fishLength: String = ""
    
    
    var time: String {
        var totalTime = 0.0
        for catches in spot.pastCatches {
            totalTime += catches.values.first ?? 0
        }
        
        var numCatches = Double(spot.pastCatches.count)
        
        var averageTime = (totalTime / numCatches)
        return averageTime.formatted()
    }
    
    var stopwatchTime: String {
        elapsedTime.formatted()
        
    }
    var body: some View {
        NavigationView {
            VStack {
                Text("Catch Time Tracker")
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .font(.system(size: 20))
                
                HStack {
                    Text("Average Time to Catch a Fish:")
                    Text(time)
                }
                .padding(.top, 20)
                
                
                Spacer()
                
                Text(stopwatchTime + " seconds")
                    .font(.system(size: 30))

                Button {
                    if !timerRunning {
                        startTime()
                    } else {
                        stopTime()
                    }
                } label: {
                    Text(timerRunning ? "STOP" : "START")
                }
                .frame(width: 150, height: 45)
                .background(.blue)
                .clipShape(.capsule)
                .foregroundColor(.white)
                .padding(.top, 40)
                
                Spacer()
                
                if !timerRunning {
                    Section {
                        Text("Ready to Record a Catch?")
                        
                        HStack {
                            Text("Fish Length: ")
                            TextField("Length", text: $fishLength)
                            
                        } .frame(width: 335)
                            .padding(.top, 20)
                        
                        Button {
                            recordTime(length: fishLength, time: elapsedTime)
                            
                            
                        } label: {
                            Text("RECORD CATCH")
                        }
                        .frame(width: 150, height: 45)
                        .background(.blue)
                        .clipShape(.capsule)
                        .foregroundColor(.white)
                        .padding(.top, 40)
                        
                    }
                }
                    
                Spacer()
                    
                
            }
        } .navigationBarBackButtonHidden(true)
    }
    func startTime() {
        timerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            elapsedTime += 0.01
            
        }
        
    }
    
    func stopTime() {
        timerRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func recordTime(length: String, time: TimeInterval) {
        var size = Int(length)!
        var entry: [Int: TimeInterval] = [size: time]
        spot.pastCatches.append(entry)
        elapsedTime = 0.0
        stopTime()
    }
    
    
}

struct BaitManagerView: View {
    @State var spot: FishingSpot
    @State private var waterPurchased: Int = 0
    
    @State private var baitRemaining = 0
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Bait Manager")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20))
                    .padding(.top, 20)
                    .fontWeight(.bold)
                
                HStack {
                    Text("How much bait did you purchase? (in pints of water)")
                    Picker("Water purchased:", selection: $waterPurchased) {
                        ForEach(1..<7, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                } .frame(width: 330)
                    .padding(.top, 40)
                
                Button {
                    baitRemaining = waterPurchased * 30
                } label: {
                    Text("Submit")
                }
                .frame(width: 150, height: 45)
                .background(.blue)
                .clipShape(.capsule)
                .foregroundColor(.white)
                .padding(.top, 40)
                
                Text("Bait Remaining: " + "\(baitRemaining)")
                
                HStack{
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .foregroundColor(.green)
                        .frame(width: 25, height: 25)
                        .onTapGesture {
                            baitRemaining += 1
                            
                        }
                    
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .foregroundColor(.red)
                        .frame(width: 25, height: 25)
                        .onTapGesture {
                            baitRemaining -= 1
                        }
                    
                } .padding(.bottom, 40)
                
                
                
                Spacer()
            }
        } .navigationBarBackButtonHidden(true)
    }
    
}

struct SessionView: View {
    
    @State var sessionNum: FishingSession
    @State var spot: FishingSpot
    @State private var canInitiateEdit: Bool = true
    @State private var selectedStartTime: Date = Date()
    @State private var selectedEndTime: Date = Date()
    @State private var editForm: Bool = false
    @State private var editing: String = ""
    @State private var changingInfo: Bool = false
    @State private var editChoice: Int = 0
    @State private var newDate: Date = Date()
    @State private var newText: String = ""
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text(dateFormatter.string(from: sessionNum.date) + " at " + spot.name)
                    .fontWeight(.bold)
                    .font(.system(size:20))
                    .padding(.top, 20)
                HStack {
                    Text("Start Time:")
                    DatePicker("Select a time:", selection: $selectedStartTime, displayedComponents: [.hourAndMinute])
                        .labelsHidden()
                      
                      
                    
                    Text("End Time:")
                    DatePicker("Select a time:", selection: $selectedEndTime, displayedComponents: [.hourAndMinute])
                        .labelsHidden()
                  
                       
                    
                    if selectedEndTime.compare(selectedStartTime) == .orderedAscending {
                        Text("Pick a time that is after the start time!")
                            .foregroundColor(.red)
                    }
                }
                .padding(.top, 20)
                Text("Weather: " + sessionNum.weather)
                    .padding(.top, 20)
                
                Text("Total fish caught: " + "\(sessionNum.fishCaught)")
                    .padding(.top, 40)
                Text("Fishing Technique: " + sessionNum.fishingTechnique)
                    .padding(.top, 40)
                
                Text("Biggest Fish Length: " + "\(sessionNum.biggestFishLength)")
                    .padding(.top, 40)
                
                if canInitiateEdit {
                    Button {
                        canInitiateEdit = false
                        editForm = true
                    } label: {
                        Text("Edit Info")
                    }
                    .frame(width: 150, height: 45)
                    .background(.blue)
                    .clipShape(.capsule)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                }
                
                if editForm {
                    Text("What data would you like to edit?")
                        .padding(.top, 40)
                    Picker("Data", selection: $editing) {
                        ForEach(editOptions, id: \.self) { option in
                            Text(option)
                            
                        }
                        
                    }
                    
                    Button {
                        editForm = false
                        editInfo(selectedCategory: editing)
                        changingInfo = true
                    } label: {
                        Text("Submit")
                    }
                    .frame(width: 150, height: 45)
                    .background(.blue)
                    .clipShape(.capsule)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                    
                }
                if changingInfo {
                    
                    if editChoice == 0 {
                        HStack {
                            Text("Choose a new date:")
                            DatePicker("Select a new date:", selection: $newDate, displayedComponents: [.date])
                                .labelsHidden()
                        }
                        Button {
                            changingInfo = false
                            sessionNum.date = newDate
                            canInitiateEdit = true
                        } label: {
                            Text("Submit")
                        }
                        .frame(width: 150, height: 45)
                        .background(.blue)
                        .clipShape(.capsule)
                        .foregroundColor(.white)
                        .padding(.top, 40)
                        
                    } else if editChoice == 1{
                        HStack {
                            Text("Correct the " + editing)
                            TextField("New", text: $newText)
                        } .frame(width: 325)
                            .padding(.top, 40)
                        
                        Button {
                            changingInfo = false
                            canInitiateEdit = true
                            switch editing {
                                case "Fish Caught":
                                sessionNum.fishCaught = Int(newText) ?? 0
                                case "Biggest Fish":
                                    sessionNum.biggestFishLength = Int(newText) ?? 0
                                case "Weather":
                                    sessionNum.weather = newText
                                case "Technique":
                                    sessionNum.fishingTechnique = newText
                                default:
                                    break
                            }
                            
                        } label: {
                            Text("Submit")
                        }
                        .frame(width: 150, height: 45)
                        .background(.blue)
                        .clipShape(.capsule)
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    }
                }
                
                Spacer()
            }
        } .navigationBarBackButtonHidden(true)
    }
    func editInfo(selectedCategory: String) {
        switch selectedCategory {
        case "Date":
            editChoice = 0
        case "Fish Caught":
            editChoice = 1
        case "Biggest Fish":
            editChoice = 1
        case "Weather":
            editChoice = 1
        case "Technique":
            editChoice = 1
        default:
            editChoice = 0
            
            
        }
        changingInfo = true
        editForm = false
        
    }
}

struct EquipmentManagerView: View {
    @State var spot: FishingSpot
    @State private var sessionLength: Int = 0
    @State private var equipmentRecommendation: Double = 0
    @State private var submitted: Bool = false
    var body: some View {
        NavigationView {
            VStack {
                Text("Equipment Manager")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                
                HStack {
                    Text("How long will you be fishing for? (in hours)")
                    Picker("Session Length:", selection: $sessionLength) {
                        ForEach(1..<10, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                } .frame(width: 330)
                
                Button {
                    recommendLineLength(time: Double(sessionLength), obstacles: spot.numberObstacles)
                    
                } label: {
                    Text("Submit")
                }
                .frame(width: 150, height: 45)
                .background(.blue)
                .clipShape(.capsule)
                .foregroundColor(.white)
                .padding(.top, 40)
                
                if submitted {
                    Text("You should consider setting " + "\(equipmentRecommendation)" + " inches between your hook and weight!")
                        .padding(.top, 40)
                        .frame(width: 330)
                }
                
                Spacer()
            }
        } .navigationBarBackButtonHidden(true)
    }
    func recommendLineLength(time: Double, obstacles: Int) {
        equipmentRecommendation = 0
        equipmentRecommendation += (time * 0.5) + (Double(obstacles) * 0.4)
        submitted = true
    }
}

