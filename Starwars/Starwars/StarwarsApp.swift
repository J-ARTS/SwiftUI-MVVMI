//
//  StarwarsApp.swift
//  Starwars
//
//  Created by Jeremy Teichmann on 30.09.21.
//

import SwiftUI
import AlamofireNetworkActivityLogger

@main
struct StarwarsApp: App {
    
    @StateObject var viewRouter = ViewRouter()
    
    init() {
        _ = DIContainer()
        NetworkActivityLogger.shared.startLogging()
    }
    var body: some Scene {
        WindowGroup {
            viewRouter.navigate(to: .DashboardPage).environmentObject(viewRouter)
        }
    }
}
