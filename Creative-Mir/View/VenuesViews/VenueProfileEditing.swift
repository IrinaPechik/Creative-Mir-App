//
//  VenueProfileEditing.swift
//  Creative-Mir
//
//  Created by Irina Pechik on 08.04.2024.
//

import SwiftUI

// TODO: CHANGE
protocol VenueProfileViewModelling: ObservableObject {
    var name: String {get set}
    var surname: String {get set}
    var email: String {get set}
    var birthdaydate: Date {get set}
    var currentBuildingAddress: String {get set}
    var avatarImage: UIImage {get set}
    var returnedPlace: Place {get set}
    
    var returnedBuildingPlace: Place {get set}
    var locationName: String {get set}
    var locationDescription: String {get set}
    var companyName: String? {get set}
    var companyPosition: String? {get set}

    func changeUserInfo(completion: @escaping (Result<MWUser, Error>) -> ())
    func changeVenueInfo(legalStatus: String, completion: @escaping (Result<MWVenue, Error>) -> ())
}

struct VenueProfileEditing<ViewModel: VenueProfileViewModelling>: View {
    @ObservedObject var viewModel: ViewModel
    @Binding var user: MWUser
    @Binding var venue: MWVenue
    @State private var isEmailValid = true
    @Binding var isEditing: Bool

    let startDate = Calendar.current.date(from: DateComponents(year: 1900, month: 1, day: 1)) ?? Date()
    let endDate = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()) - 14, month: 12, day: 31)) ?? Date()
    var body: some View {
        NavigationStack {
            VStack {
                Text("Edit your personal data")
                    .font(customFont: .PlayfairDisplayMedium, size: 24)
                Form {
                    Section {
                        NavigationLink {
                            Text("Enter your name and surname")
                                .font(customFont: .PlayfairDisplayMedium, size: 24)
                            Form {
                                Section {
                                    customTextView(name: $viewModel.name, placeholderName: "Name")
                                }
                                Section {
                                    customTextView(name: $viewModel.surname, placeholderName: "Surname")
                                }
                            }
                        } label: {
                            Label("\(viewModel.name) \(viewModel.surname)", systemImage: "timer")
                        }
                    } header: {
                        Text("Name and surname")
                    }
                    
                    Section {
                        NavigationLink {
                            Form {
                                Section {
                                    customEmailTextView(email: $viewModel.email, isEmailValid: $isEmailValid, placeholderName: "Email")
                                }
                            }
                        }
                    label: {
                        Label("\(viewModel.email)", systemImage: "timer")
                    }
                    } header: {
                        Text("email")
                    }
                    .listRowBackground(!isEmailValid ? Color.red.opacity(0.2) : Color.white)
                    
                    
                    Section {
                        NavigationLink("\(viewModel.returnedBuildingPlace.fullAddress.isEmpty ? viewModel.currentBuildingAddress : viewModel.returnedBuildingPlace.fullAddress)") {
                            FullAddressLokupView(returnedPlace: $viewModel.returnedBuildingPlace).environmentObject(LocationManager())
                        }
                    } header: {
                        Text("Location address")
                    }
                    
                    if !(venue.advertisements[0].companyName == nil) {
                        Section {
                            NavigationLink {
                                Form {
                                    Section {
                                        customTextView3(name: $viewModel.companyName, placeholderName: "Company name")
                                    }
                                    Section {
                                        customTextView3(name: $viewModel.companyPosition, placeholderName: "Company position")
                                    }
                                }
                            }
                        label: {
                            Label("\(viewModel.companyName!) \(viewModel.companyPosition!)", systemImage: "timer")
                        }
                        } header: {
                            Text("Company info")
                        }
                    }
                    Section {
                        NavigationLink {
                            Text("Enter location details")
                                .font(customFont: .PlayfairDisplayMedium, size: 24)
                            Form {
                                Section {
                                    customTextView(name: $viewModel.locationName, placeholderName: "Location name")
                                }
                                Section {
                                    TextField("Location description", text: $viewModel.locationDescription, axis: .vertical)
                                        .multilineTextAlignment(.leading)
                                        .padding()
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 25)
                                                .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                        .padding()
                                        .lineLimit(9...)
                                }
                                
                            }
                        } label: {
                            Label("Location deatails", systemImage: "timer")
                        }
                    } header: {
                        Text("Location info")
                    }
                    
                    Section {
                        DatePicker("", selection: $viewModel.birthdaydate, in: startDate...endDate,displayedComponents: .date)
                            .datePickerStyle(.graphical)
                    } header: {
                        Text("Birthdate")
                    }
                }
                
                NextButtonViewSecond(buttonText: "Save", isDisabled: !isEmailValid) {
                    viewModel.changeUserInfo { res in
                        switch res {
                        case .success(let success):
                            user = success
                        case .failure(let failure):
                            print(failure.localizedDescription)
                        }
                    }
                    viewModel.changeVenueInfo(legalStatus: venue.advertisements[0].legalStatus) { res in
                        switch res {
                        case .success(let success):
                            venue = success
                        case .failure(let failure):
                            print(failure.localizedDescription)
                        }
                    }
                    isEditing = false
                }
            }
        }
    }
}

//#Preview {
//    VenueProfileEditing()
//}
