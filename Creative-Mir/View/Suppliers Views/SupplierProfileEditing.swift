//
//  SupplierProfileEditing.swift
//  Creative-Mir
//
//  Created by Irina Pechik on 08.04.2024.
//

import SwiftUI

protocol SupplierProfileViewModelling: ObservableObject {
    var name: String {get set}
    var surname: String {get set}
    var email: String {get set}
    var birthdaydate: Date {get set}
    var currentUserAddress: String {get set}
    var avatarImage: UIImage {get set}
    var returnedPlace: Place {get set}
    
    var skill: String {get set}
    var stageName: String? {get set}
    var companyName: String? {get set}
    var companyPosition: String? {get set}
    var experience: Int {get set}
    var experienceMeasure: String {get set}
    var storyAboutWork: String {get set}
    var storyAboutYourself: String {get set}
    func changeUserInfo(completion: @escaping (Result<MWUser, Error>) -> ())
    func changeSupplierInfo(legalStatus: String, completion: @escaping (Result<MWSupplier, Error>) -> ())
}

struct SupplierProfileEditing<ViewModel: SupplierProfileViewModelling>: View {
    @ObservedObject var viewModel: ViewModel
    @Binding var user: MWUser
    @Binding var supplier: MWSupplier
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
                            Text("Edit your name and surname")
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
                            Label("\(viewModel.name) \(viewModel.surname)", systemImage: "person")
                        }
                    } header: {
                        Text("Name and surname")
                    }

                    Section{
                        NavigationLink {
                            Text("Edit your email")
                                .font(customFont: .PlayfairDisplayMedium, size: 24)
                            Form {
                                Section {
                                    customEmailTextView(email: $viewModel.email, isEmailValid: $isEmailValid, placeholderName: "Email")
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
                        }
                    } header: {
                        Text("Location address")
                    }
                    
                    if !(supplier.advertisements[0].stageName == nil) {
                        Section {
                            NavigationLink {
                                Text("Edit your stage name")
                                    .font(customFont: .PlayfairDisplayMedium, size: 24)
                                Form {
                                    Section {
                                        customTextView3(name: $viewModel.stageName, placeholderName: "Stage name")
                                    }
                                }
                            }
                            label: {
                                Label("\(viewModel.stageName == nil ? supplier.advertisements[0].stageName! : viewModel.stageName!)", systemImage: "person")
                            }
                        } header: {
                            Text("Stage name")
                        }
                    } else if !(supplier.advertisements[0].companyName == nil) {
                        Section {
                            NavigationLink {
                                Text("Edit company name and your position")
                                    .font(customFont: .PlayfairDisplayMedium, size: 24)
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
                                Label("\(viewModel.companyName == nil ? supplier.advertisements[0].companyName! : viewModel.companyName!) \(viewModel.companyPosition == nil ? supplier.advertisements[0].companyPosition! : viewModel.companyPosition!)", systemImage: "building.2.fill")
                            }
                        } header: {
                            Text("Company info")
                        }
                    }
                    
                    Section {
                        NavigationLink {
                            Text("Edit your work experience info")
                                .font(customFont: .PlayfairDisplayMedium, size: 24)
                            Form {
                                Section {
                                    TextField("Write about your work experience", text: $viewModel.storyAboutWork, axis: .vertical)
                                        .multilineTextAlignment(.leading)
                                        .padding()
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 25)
                                                .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                        .padding()
                                        .lineLimit(9...)
                                        .font(.custom("Lora-Regular", size: 18))
                                }
                            }
                        }
                        label: {
                            Label("Story about work", systemImage: "pencil.and.outline")
                        }
                    } header: {
                        Text("Story about work")
                    }
                    
                    Section {
                        NavigationLink {
                            Text("Edit your story about yourself")
                                .font(customFont: .PlayfairDisplayMedium, size: 24)
                            Form {
                                Section {
                                    TextField("Reveal your personality", text: $viewModel.storyAboutYourself, axis: .vertical)
                                        .multilineTextAlignment(.leading)
                                        .padding()
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 25)
                                                .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                        .padding()
                                        .lineLimit(9...)
                                        .font(.custom("Lora-Regular", size: 18))
                                }
                            }
                        }
                        label: {
                            Label("Story about yourself", systemImage: "pencil.and.outline")
                        }
                    } header: {
                        Text("Story about yourself")
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
                    viewModel.changeSupplierInfo(legalStatus: supplier.advertisements[0].legalStatus) { res in
                        switch res {
                        case .success(let success):
                            supplier = success
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
//    SupplierProfileEditing(viewModel: SupplierProfileViewModel())
//}
