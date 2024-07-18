//
//  ExploreView.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 18/7/24.
//

import SwiftUI

struct ExploreView: View {
    
    @State private var searchText = ""
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(0 ... 1, id: \.self) { user in
                        VStack {
                            UserCell()
                            Divider()
                        }
                        .padding(.vertical, 4)
                    }
                    .navigationTitle("Seach")
                    .searchable(text: $searchText, prompt: "Search")
                }
            }
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
