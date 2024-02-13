//
//  ContentView.swift
//  FishBot
//
//  Created by Alex Lee on 2/12/24.
//

import SwiftUI

struct HomeView: View {
    @State private var userDatabase: UserDatabase = creation
    
    @State private var askNew = false
    @State private var nameError = false
    @State private var nameText = ""
    @State private var deleteMode = false
    
    
    var body: some View {
        
        NavigationView {
            VStack {
               
                Text("Welcome to FishBot!")
                    .fontWeight(.bold)
                    .font(.system(size:20))
                    .padding(.top, 20)
                
                
                HStack{
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .foregroundColor(.green)
                        .frame(width: 25, height: 25)
                        .onTapGesture{
                            changeFishingSpots(hasInfo: false, add: true)
                            deleteMode = false
                            askNew = true
                        }
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .foregroundColor(.red)
                        .frame(width: 25, height: 25)
                        .onTapGesture {
                            changeFishingSpots(hasInfo: false, add: false)
                            deleteMode = true
                            askNew = true
                        }
                    
                } 
                .padding(.top, 10)
                .padding(.bottom, 40)
                   
                if askNew {
                        VStack {
                            ZStack {
                                Rectangle()
                                    .fill(Color(red: 0.9, green: 0.9, blue: 0.9))
                                    .frame(width: 355, height: 300)
                                    .cornerRadius(8)
                                Text(deleteMode ? "Enter the name of the fishing spot you would like to delete:" : "Enter the name of the fishing spot you would like to add:")
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
                                        changeFishingSpots(hasInfo: true, add: false)
                                    } else {
                                        changeFishingSpots(hasInfo: true, add: true)
                                    }
                                    
                                } label: {
                                    Text(deleteMode ? "Delete Spot": "Add New Spot")
                                }
                                
                                .frame(width: 150, height: 45)
                                .background(.blue)
                                .clipShape(.capsule)
                                .foregroundColor(.white)
                                .padding(.top, 40)
                                
                                
                                if nameError {
                                    Text(deleteMode ? "That name doesn't exist! Try again!" : "You've already used that name! Try again!")
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
                    
                    
                List(creation.allFishingSpots) { spot in
                    NavigationLink(destination: LakeView(lake: spot)) {
                        Text(spot.name)
                    }
                }
                    
            }
                
        }
       
    }
    
    func changeFishingSpots(hasInfo: Bool, add: Bool) {
        
        if !hasInfo {
            nameError = false
            askNew.toggle()
            return
        }
        if add {
            nameError = false
            deleteMode = false
            
            if hasInfo {
                for spot in creation.allFishingSpots {
                    if spot.name == nameText {
                        nameError = true
                        return
                    }
                }
                var newSpot = FishingSpot()
                newSpot.name = nameText
                creation.allFishingSpots.append(newSpot)
                nameText = ""
                askNew.toggle()
                nameError = false
            }
                
        } else {
            nameError = false
            var isFound = false
            for spot in creation.allFishingSpots {
                if spot.name == nameText {
                    isFound = true
                }
            }
            if isFound {
                creation.allFishingSpots.removeAll { $0.name == nameText }
            } else {
                nameError = true
                return
            }
        }
    }
    
}
    


#Preview {
    HomeView()
}
