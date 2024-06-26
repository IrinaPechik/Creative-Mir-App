//
//  CustomerProfileEditing.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 06.04.2024.
//

import SwiftUI
import MapKit

protocol CustomerProfileViewModelling: ObservableObject {
    var name: String {get set}
    var surname: String {get set}
    var email: String {get set}
    var birthdaydate: Date {get set}
    var currentUserAddress: String {get set}
    var avatarImage: UIImage {get set}
    var returnedPlace: Place {get set}
    func changeCustomerInfo(completion: @escaping (Result<MWUser, Error>) -> ())
}

struct CustomerProfileEditing<ViewModel: CustomerProfileViewModelling>: View {
    @ObservedObject var viewModel: ViewModel

    @State private var isEmailValid = true
    @Binding var isEditing: Bool
    @Binding var user: MWUser?
    
    let startDate = Calendar.current.date(from: DateComponents(year: 1900, month: 1, day: 1)) ?? Date()
    let endDate = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()) - 14, month: 12, day: 31)) ?? Date()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Edit your personal data")
                    .font(customFont: .PlayfairDisplayMedium, size: 24)
                Form {
                    Section {
                        NavigationLink {
                            VStack {
                                Text("Change your name and surname")
                                    .font(customFont: .PlayfairDisplayMedium, size: 24)
                                Form {
                                    Section {
                                        customTextView(name: $viewModel.name, placeholderName: "Name")
                                    }
                                    Section {
                                        customTextView(name: $viewModel.surname, placeholderName: "Surname")
                                    }
                                }
                            }
                            .navigationBarBackButtonHidden(true)
                            .toolbar {
                                ToolbarItem(placement: .topBarLeading) {
                                    customBackButton()
                                }
                            }
                        } label: {
                            Label("\(viewModel.name) \(viewModel.surname)", systemImage: "person")
                        }
                    } header: {
                        Text("Name and surname")
                    }

                    Section{
                        NavigationLink {
                            VStack {
                                Text("Change your email")
                                    .font(customFont: .PlayfairDisplayMedium, size: 24)
                                Form {
                                    Section {
                                        customEmailTextView(email: $viewModel.email, isEmailValid: $isEmailValid, placeholderName: "Email")
                                    }
                                }
                            }        // Скрываем системную кнопку Back
                            .navigationBarBackButtonHidden(true)
                            .toolbar {
                                ToolbarItem(placement: .topBarLeading) {
                                    customBackButton()
                                }
                            }
                        }
                        label: {
                            Label("\(viewModel.email)", systemImage: "envelope")
                        }
                    } header: {
                        Text("email")
                    }
                    .listRowBackground(!isEmailValid ? Color.red.opacity(0.2) : Color.white)
                    
                    
                    Section {
                        NavigationLink("\(viewModel.returnedPlace.address.isEmpty ? viewModel.currentUserAddress : viewModel.returnedPlace.address)") {
                            PlaceLookupView(returnedPlace: $viewModel.returnedPlace).environmentObject(LocationManager())
                                .navigationBarBackButtonHidden(true)
                                .toolbar {
                                    ToolbarItem(placement: .topBarLeading) {
                                        customBackButton()
                                    }
                                }
                        }
                    } header: {
                        Text("Location address")
                    }
                    
                    Section {
                        DatePicker("", selection: $viewModel.birthdaydate, in: startDate...endDate,displayedComponents: .date)
                            .datePickerStyle(.graphical)
                    } header: {
                        Text("Birthdate")
                    }
                }
                NextButtonViewSecond(buttonText: "Save", isDisabled: !isEmailValid) {
                    viewModel.changeCustomerInfo { res in
                        switch res {
                        case .success(let success):
                            user = success
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
//    CustomerProfileEditing(viewModel: CustomerProfileViewModel(), isEditing: <#Binding<Bool>#>)
//}
