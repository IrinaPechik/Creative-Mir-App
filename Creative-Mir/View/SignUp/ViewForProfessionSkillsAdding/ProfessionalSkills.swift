//
//  ProfessionalSkills.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 29.02.2024.
//

import SwiftUI


struct ProfessionalSkills: View {
    @State var storyAboutProfession: String = ""
    @State private var presentNextView = false
    @State private var selectedNumber = 0
    @State private var selectedUnit: Experience = .years
    @State private var supplierProfession: SupplierProfession = .noneValue
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Your profession")
                    .font(.custom("Lora-Regular", size: 30))
                
                VStack(alignment: .leading) {
                    // Choosing profession
                    ProfessionChoosingView(supplierProfession: $supplierProfession)
                    // Work experience
                    ExperienceInputView(selectedNumber: $selectedNumber, selectedUnit: $selectedUnit)
                }
                
                TextField("Write about your career", text: $storyAboutProfession, axis: .vertical)
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
                    .frame(width: 340)
                NextButtonViewSecond(buttonText: "N E X T", isDisabled: isNextButtonDisabled()) {
                    AuthService.shared.saveSupplierFirstSkill(supplierFirstSkill: supplierProfession.rawValue)
                    AuthService.shared.saveSupplierFirstSkillExperience(supplierFirstSkillExperience: selectedNumber)
                    AuthService.shared.saveSupplierFirstSkillExperienceMeasure(supplierFirstSkillExperienceMeasure: selectedUnit.rawValue)
                    AuthService.shared.saveSupplierStoryAboutWork(storyAboutWork: storyAboutProfession)
                    presentNextView.toggle()
                }
            }
            .navigationDestination(isPresented: $presentNextView) {
                Text("upploading photo")
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
                PageCounter(currentCounter: 4, allPagesCount: 7)
            }
        }
    }
    
    func isNextButtonDisabled() -> Bool {
        if supplierProfession != .noneValue && !storyAboutProfession.isEmpty {
            return false
        } 
        return true
    }
}

#Preview {
    ProfessionalSkills()
}
