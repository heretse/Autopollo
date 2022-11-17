//
//  FormView.swift
//  Autopollo
//
//  Created by Winston Hsieh on 2022/10/16.
//

import SwiftUI

struct FormView: View {
    @State var companyCode: String = ""
    @State var employeeNo:  String = ""
    @State var password:    String = ""
    
    let userDefaults = UserDefaults.standard
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("LOGIN")) {
                    TextField("Company Code", text: $companyCode)
                    TextField("Employee Number", text: $employeeNo)
                    TextField("Password", text: $password)
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            print("companyCode = \(companyCode), employeeNo = \(employeeNo), password = \(password)")
                            if companyCode != "" {
                                userDefaults.setValue(companyCode, forKey: DefaultsKeys.companyCode)
                            }
                            if employeeNo != "" {
                                userDefaults.setValue(employeeNo, forKey: DefaultsKeys.employeeNo)
                            }
                            if password != "" {
                                userDefaults.setValue(password, forKey: DefaultsKeys.password)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                Darwin.exit(0)
                            }
                        }, label: {
                            Text("Save")
                                .foregroundColor(.white)
                                .frame(width: 200, height: 40)
                                .background(Color.init(cgColor: CGColor.init(red: 0.0, green: 160.0, blue: 180.0, alpha: 1.0)))
                                .cornerRadius(15)
                                .padding()
                        })
                        Spacer()
                    }
                }
            }
            .navigationBarTitle("Apollo Setup")
        }
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView()
    }
}
