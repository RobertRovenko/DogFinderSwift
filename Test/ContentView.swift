//
//  ContentView.swift
//  Test
//
//  Created by Robert Falkbäck on 2023-08-25.
//

import SwiftUI

struct ContentView: View {
    @State private var currentImageIndex = 0
    @State private var dogs: [(name: String, image: String)] = [
        ("Kantarell", "image1"),
        ("Bingo", "image2"),
        ("Tuscani", "image3"),
        ("Charlie", "image4")
    ]
    @State private var isNoDogsLeft = false // Track if there are no dogs left
    @State private var showNotification = false
    @State private var removedDogs: [(name: String, image: String)] = [] // Track removed dogs
    @State private var messagesBadgeCount = 0 // Badge count for Messages tab
    @State private var messagesTabTapped = false
   
   
    var body: some View {
        TabView {
            // Home View
            
            VStack {
                
                Text("Dachshund Finder")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .bold()
                Text("Adopt a dog!")
                    .navigationTitle("Adopt a dog!")
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding(.top, 40)
                    .bold()

                Spacer()

                if !isNoDogsLeft {
                    Text(dogs[currentImageIndex].name) // Display the image name
                        .foregroundColor(.black)
                        .font(.title)

                    Image(dogs[currentImageIndex].image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 350, height: 350)
                } else {
                    // Display a message when there are no dogs left
                    Text("No dogs left")
                        .font(.title)
                        .foregroundColor(.red)
                        .padding()

                    // Undo button to restore removed dogs
                    Button(action: {
                        dogs.append(contentsOf: removedDogs)
                        removedDogs.removeAll()
                        isNoDogsLeft = false
                    }) {
                        Text("Reset")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }

                Spacer()

                HStack {
                    if !isNoDogsLeft {

                        Button(action: {
                            if currentImageIndex == 0 {
                                currentImageIndex = dogs.count - 1
                            } else {
                                currentImageIndex -= 1
                            }
                        }) {
                            Text("Back")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 100, height: 50)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }

                        Spacer()

                        Button(action: {
                            // Capture the current dog's name and image
                            let currentDog = dogs[currentImageIndex]

                            // Remove the selected dog from the array
                            if let index = dogs.firstIndex(where: { $0.name == currentDog.name }) {
                                dogs.remove(at: index)
                                removedDogs.append(currentDog)
                            }

                            // Automatically move to the next dog
                            if currentImageIndex == dogs.count {
                                currentImageIndex = 0
                            }

                            // Check if there are no dogs left
                            if dogs.isEmpty {
                                isNoDogsLeft = true
                            }

                            // Show the notification
                            showNotification = true

                            // Hide the notification after 2 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showNotification = false
                            }

                            // Increment the badge count for Messages tab
                            messagesBadgeCount += 1
                        }) {
                            Image(systemName: "message")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                        }
                        .buttonStyle(PlainButtonStyle())

                        Spacer()

                        Button(action: {
                            if currentImageIndex == dogs.count - 1 {
                                currentImageIndex = 0
                            } else {
                                currentImageIndex += 1
                            }
                        }) {
                            Text("Next")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 100, height: 50)
                                .background(Color.green)
                                .cornerRadius(10)
                        }


                    }
                }

                Spacer()
            }
            .padding()
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }

    
       
            // Messages View with custom badge
            MessagesView(messagesBadgeCount: $messagesBadgeCount)
                .tabItem {
                    VStack {
                        Image(systemName: "message")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                        Text("Messages")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                    }
                }
                .badge(messagesBadgeCount > 0 ? "\(messagesBadgeCount)" : nil)
                .onAppear {
                    // Reset the badge count to 0 when the tab is displayed
                    messagesBadgeCount = 0
                }

                //.badge(messagesBadgeCount > 0 ? "\(messagesBadgeCount)" : nil)

            // Settings View
           
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .onAppear {
                   // Initialize currentImageIndex
                   currentImageIndex = 0
               }        .alert(isPresented: $showNotification) {
            Alert(
                title: Text("Dog Added"),
                message: Text("Check your conversations"),
                dismissButton: .default(Text("Ok"))
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MessagesView: View {
    @Binding var messagesBadgeCount: Int
    
    var body: some View {
        NavigationView {
            Text("Messages")
                .navigationBarTitle("Messages")
        }
    }
}



struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    // Add more settings properties as needed

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                    Toggle("Dark Mode", isOn: $darkModeEnabled)
                    // Add more settings options here
                }

                Section(header: Text("Account")) {
                    Text("Username: Guest")
                    Button(action: {
                        // Add action for changing the username
                    }) {
                        Text("Change Username")
                            .foregroundColor(.blue)
                    }
                    // Add more account-related settings here
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}

