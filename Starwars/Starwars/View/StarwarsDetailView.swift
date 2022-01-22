//
//  StarwarsDetailView.swift
//  Starwars
//
//  Created by Jeremy Teichmann on 18.10.21.
//

import Foundation
import SwiftUI
import Resolver

struct StarwarsDetailView: View {
    
    let person : StarWarsPerson
    var body: some View {
        
        ScrollView {
            HStack {
                VStack(alignment: .leading) {
                    Text("app-mass \(person.mass ?? "app-no-mass")")
                    Text("app-gender \(person.gender ?? "app-no-gender")")
                    Text("app-hairColor \(person.hairColor ?? "app-no-hairColor")")
                    Text("app-height \(person.height ?? "app-no-height")")
                }.padding(20)
                Spacer()
            }
        }.navigationTitle(person.name ?? "app-no-name")
    }
}

struct StarwarsDetailView_Previews: PreviewProvider {
    
    static var item =  StarWarsPerson(name: nil, height: nil, mass: nil, hairColor: nil, gender: nil, films: nil)
    static var previews: some View {
        StarwarsDetailView(person: item)
    }
}
