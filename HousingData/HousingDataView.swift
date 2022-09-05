//
//  ContentView.swift
//  HousingData
//
//  Created by Scott Andrew on 8/2/22.
//

import SwiftUI
import Charts

struct HousingDataView: View {
    @ObservedObject var housingModel = HousingDataModel();
    @State private var showError = false;
    @State private var selectedItems = Set<RegionData.ID>()
    @FocusState var inFocus;
    
    var body: some View {
        return VSplitView {
            chart()
            table()
        }
        .task {
            do {
                try await housingModel.sync()
                await MainActor.run {
                    inFocus = true
                    selectedItems = [housingModel.data[0].id]
                }
            } catch {
                showError = true
            }
        }
        .alert("Can not get housing data", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        }
        .onChange(of: selectedItems) { newSelection in
            if newSelection.count <= 10 {
                housingModel.lastSelection = newSelection
            }
            else {
                selectedItems = housingModel.lastSelection
            }
        }
    }
    
    @ViewBuilder
    func table() -> some View {
        Table(housingModel.data, selection: $selectedItems) {
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
        .focused($inFocus)
    }
    
    @ViewBuilder
    func chart() -> some View {
        if housingModel.data.count == 0 {
            Rectangle().foregroundColor(Color.clear).frame(height: 300)
        }
        else {
           Chart(housingModel.selectedData(items: selectedItems)) { data in
                ForEach(data.values) { value in
                    if value.value != nil {
                        LineMark(
                            x: .value("Month", value.date, unit: .month),
                            y: .value("Avg. Sales", value.value ?? 0))
                    }
                }
                .foregroundStyle(by: .value("City", data.name))
            }.padding().frame(minHeight: 300, idealHeight: 300)
        }
    }
}

struct HousingDataView_Previews: PreviewProvider {
    static var previews: some View {
        HousingDataView()
    }
}
