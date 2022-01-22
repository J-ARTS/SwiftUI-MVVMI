//
//  Router.swift
//  Starwars
//
//  Created by Jeremy Teichmann on 18.10.21.
//

import Foundation
import SwiftUI


enum Route {
    case DetailPage(data : StarWarsPerson)
    case DashboardPage
}

final class ViewRouter : ObservableObject {
    @ViewBuilder
    func navigate(to: Route) -> some View  {
        switch to {
            case .DetailPage(let data):
                StarwarsDetailView(person: data)
            case .DashboardPage:
                StarwarsDashboardView()
        }
    }
}
