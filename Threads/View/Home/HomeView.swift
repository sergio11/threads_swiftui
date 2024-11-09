//
//  HomeView.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 9/11/24.
//

import SwiftUI

struct HomeView: View {
    
    @State private var selectedTab = 0
    @State private var showCreateThreadView = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        .environment(\.symbolVariants, selectedTab == 0 ? .fill: .none)
                }.onAppear {
                    selectedTab = 0
                }
                .tag(0)
            
            ExploreView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }.onAppear {
                    selectedTab = 1
                }
                .tag(1)
            Text("")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }.onAppear {
                    selectedTab = 2
                }
                .tag(2)
            ActivityView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "heart.fill" : "heart")
                        .environment(\.symbolVariants, selectedTab == 3 ? .fill: .none)
                }.onAppear {
                    selectedTab = 3
                }
                .tag(3)
            
            CurrentUserProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "person.fill" : "person")
                        .environment(\.symbolVariants, selectedTab == 4 ? .fill: .none)
                }.onAppear {
                    selectedTab = 4
                }
                .tag(4)
        }
        .onChange(of: selectedTab, perform: { newValue in
            showCreateThreadView = selectedTab == 2
        })
        .sheet(isPresented: $showCreateThreadView, onDismiss:  {
            selectedTab = 0
        }, content: {
            CreateThreadView()
        })
        .tint(.black)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

