//
//  InfoView.swift
//  YakiOSpot
//
//  Created by Raphaël Payet on 10/12/2021.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    MembershipRow(description: SampleText.annualMembership, price: SampleText.annualPrice)
                    MembershipRow(description: SampleText.dailyMembership, price: SampleText.dayPrice)
                } header: {
                    Text(SampleText.membership)
                        .foregroundColor(.red)
                }
                
                Section {
                    Text(SampleText.spotInfo)
                } header: {
                    Text("Infos")
                }
                
                Section {
                    Text(SampleText.spotOpen)
                } header: {
                    Text("Ouverture")
                }
                
                Section {
                    ForEach(DummySpot.cornillon.tracks, id: \.self) { track in
                        TrackRow(track: track)
                    }
                } header: {
                    Text("Pistes")
                }
            }
                .navigationTitle("Yaki O Spot")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: Text("Profile")) {
                            Image(systemName: "person.circle")
                                .foregroundColor(.black)
                        }
                    }
                }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}


// MARK: - Subviews
struct MembershipRow : View {
//    let link : URL
    let description: String
    let price: String
    
    var body: some View {
        NavigationLink {
            // TODO: Add a web view
            Text(description)
        } label: {
            HStack {
                Text(description)
                Spacer()
                Text(price)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct TrackRow: View {
    let track: Track
    
    var body: some View {
        NavigationLink(destination: Text(track.name)) {
            HStack {
                Image(systemName: "flag.fill")
                    .foregroundColor(track.difficulty.color)
                Spacer()
                Text(track.name)
                Spacer()
                HStack {
                    Image(systemName: "hand.thumbsup.fill")
                        .foregroundColor(.blue)
                    Text("\(track.likes)")
                }
            }
        }
    }
}