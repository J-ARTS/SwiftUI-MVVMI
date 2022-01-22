//
//  ContentView.swift
//  Starwars
//
//  Created by Jeremy Teichmann on 30.09.21.
//

// extend DI to structure, which can be find here  https://github.com/hmlongco/InjectableDemo/tree/master/InjectableDemo
// update View to display the entrys
// navigate to detail page

import SwiftUI
import Resolver

struct StarwarsDashboardView: View {

    @InjectedObject var viewModel: StarWarsViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.items) { person in
                        NavigationLink(
                            destination: {
                                viewRouter.navigate(to: .DetailPage(data: person))
                            },
                            label: {
                                StarwarsDashboardRowView(starWarsPerson: person)
                            }
                        ).foregroundColor(.black)
                    }
                }.listStyle(.grouped)
            }.navigationTitle("app-title")
        }.onAppear(perform: {
            viewModel.loadPeople()
        })
    }
}

struct StarwarsDashboardView_Previews: PreviewProvider {
    @StateObject static var viewRouter = ViewRouter()
    static var previews: some View {
        StarwarsDashboardView().environment(\.locale, .init(identifier: "de")).environmentObject(viewRouter)
    }
}
