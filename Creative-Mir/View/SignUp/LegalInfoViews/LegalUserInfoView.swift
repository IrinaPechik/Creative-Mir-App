//
//  LegalUserInfoView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 28.02.2024.
//

import SwiftUI


struct LegalUserInfoView: View {
    @State var stageName: String = ""

    @State var companyName: String = ""
    @State var position: String = ""

    @State private var isIndividualOn = false
    @State private var isCompanyOn = false

    @State private var presentNextView = false

    var body: some View {
        NavigationView {
            VStack {
                Text("You are")
                    .font(.custom("Lora-Regular", size: 32))
                    .padding(.bottom, 40)
                
                VStack(alignment: .center) {
                    // fist toggle
                    Toggle(isOn: $isIndividualOn) {
                        Text("Individual person")
                            .font(.custom("Marcellus-Regular", size: 20))
                            .padding()

                    }
                    .frame(width: 340, height: 61)
                    .toggleStyle(SwitchToggleStyle(tint: .black))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(isIndividualOn ? .black : .gray, lineWidth: isIndividualOn ? 0.5 : 0.2)
                            .frame(width: 370)
                    )
                    .onChange(of: isIndividualOn) {
                        if isIndividualOn {
                            isCompanyOn = false
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // second toggle
                    Toggle(isOn: $isCompanyOn) {
                        Text("Company")
                            .font(.custom("Marcellus-Regular", size: 20))
                            .padding()

                    }
                    .frame(width: 340, height: 61)
                    .toggleStyle(SwitchToggleStyle(tint: .black))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(isCompanyOn ? .black : .gray, lineWidth: isCompanyOn ? 0.5 : 0.2)
                            .frame(width: 370)
                    )
                    .padding(.bottom, 20)
                    .onChange(of: isCompanyOn) {
                        if isCompanyOn {
                            isIndividualOn = false
                        }
                    }
                    
                    if isCompanyOn {
                        customTextView2(name: $companyName, placeholderName: "Company name *")
                        customTextView2(name: $position, placeholderName: "Position *")
                    }
                }
                NextButtonViewSecond(buttonText: "N E X T", isDisabled: isNextButtonDisabled()) {
                    if isCompanyOn {
                        AuthService.shared.savePerformerCompanyOrIndividualStatus(companyOrIndividualStatus: "company")
                        AuthService.shared.savePerformerCompanyName(companyName: companyName)
                        AuthService.shared.savePerformerPositionInCompany(position: position)
                    } else if isIndividualOn {
                        AuthService.shared.savePerformerCompanyOrIndividualStatus(companyOrIndividualStatus: "individual")
                    }
//                    // Переход к следующей view
                    presentNextView.toggle()
                }
                .padding(.top, 100)
            }
            .navigationDestination(isPresented: $presentNextView) {
                switch AuthService.shared.getUserRole() {
                case String(describing: UserRoles.supplier):
                    if isIndividualOn {
                        StageNameInfoView()
                    } else {
                        ProfessionalSkills()
                    }
                case String(describing: UserRoles.venue):
                    AddingBuildingLocationView()
                default:
                    // Ошибочка, перенаправить на главную страницу
                    Text("user")
                }
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        // Скрываем системную кнопку Back
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                customBackButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                PageCounter(currentCounter: 3, allPagesCount: 5)
            }
        }

    }
    
    func isNextButtonDisabled() -> Bool {
        if isIndividualOn {
            return false
        } else if !companyName.isEmpty && !position.isEmpty && isCompanyOn {
            return false
        }
        return true
    }
}

#Preview {
    LegalUserInfoView()
}
