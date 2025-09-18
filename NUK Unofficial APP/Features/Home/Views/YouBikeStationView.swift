//
//  YouBikeStationView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/2/6.
//

import SwiftUI

struct YouBikeStationView: View {
    @EnvironmentObject private var viewModel: YouBikeViewModel
    let youBike: YouBike
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: "rectangle.portrait.fill")
                .resizable()
                .frame(width: 6, height: 28)
                .foregroundColor(Color("\(viewModel.getAvailableStatus(youBike: youBike).rawValue)"))
            VStack(alignment: .leading, spacing: 0) {
                Text("\(youBike.name)")
                    .font(.system(size: 16))
                    .foregroundColor(Color("DARK_GRAY"))
                Text("\(youBike.availableSpace) 輛可借、\(youBike.parkingSpace - youBike.availableSpace) 輛可停")
                    .font(.system(size: 12))
                    .foregroundColor(Color("DARK_GRAY"))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct YouBikeStationView_Previews: PreviewProvider {
    static var previews: some View {
        YouBikeStationView(youBike: YouBike(id: 1, name: "第一綜合大樓", parkingSpace: 45, availableSpace: 5, dateTime: Date()))
            .previewLayout(.sizeThatFits)
            .environmentObject(YouBikeViewModel())
    }
}
