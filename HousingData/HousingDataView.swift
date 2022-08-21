//
//  ContentView.swift
//  HousingData
//
//  Created by Scott Andrew on 8/2/22.
//

import SwiftUI

struct HousingDataView: View {
    @ObservedObject var housingModel = HousingDataModel();
    @State private var showError = false;
    
    var body: some View {
        VStack {
            Table(housingModel.data) {
                TableColumn("Rank") { region in
                    Text("\(region.rank)")
                }
                .width(30)
                TableColumn("Region", value:\.name)
                TableColumn("Type") {region in
                    Text("\(region.type == .metro ? "Metro" : "Country")")
                }
                .width(100)
                TableColumn("State") { region in
                    Text(region.state ?? "")
                }
                .width(50)
            }
        }
        .task {
            do {
                try await housingModel.sync()
            } catch {
                showError = true
            }
        }
        .alert("Can not get housing data", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        }
    }
}

struct HousingDataView_Previews: PreviewProvider {
    static var previews: some View {
        HousingDataView()
    }
}
