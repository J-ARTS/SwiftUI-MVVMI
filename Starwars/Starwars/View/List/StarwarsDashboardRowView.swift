//
//  StarwarsDashboardRowView.swift
//  Starwars
//
//  Created by Jeremy Teichmann on 17.10.21.
//

import SwiftUI
import Resolver

struct StarwarsDashboardRowView: View {
    @State var starWarsPerson : StarWarsPerson
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(starWarsPerson.name ?? "app-no-name").font(.body)
                        Text(starWarsPerson.gender ?? "app-no-gender").font(.body)
                    }
                }
                Spacer()
                Image(systemName: "chevron.forward")
            }
            .padding(.trailing, 20)
            .padding(.leading, 20)
            Divider()
        }
    }
}

struct StarwarsDashboardRowView_Previews: PreviewProvider {
    @State static var item =  StarWarsPerson(name: "Test", height: "Test", mass: "Test", hairColor: "Test", gender: "men", films: nil)
    static var previews: some View {
        StarwarsDashboardRowView(starWarsPerson: item)
    }
}
