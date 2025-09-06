//
//  AnnotationItemView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/2/7.
//

import SwiftUI
import MapKit

struct AnnotationItemView: View {
    @EnvironmentObject private var youBikeViewModel: YouBikeViewModel
    @EnvironmentObject private var viewModel: MapViewModel
    let annotationItem: AnnotationItem
    
    var body: some View {
        Image("\(annotationItem.category.rawValue)")
            .resizable()
            .scaledToFit()
            .frame(height: 48)
            .scaleEffect(viewModel.isFocus(annotationItem: annotationItem) ? 1: 0.7)
            .onTapGesture {
                viewModel.setFocus(annotationItem: annotationItem)
                viewModel.setYouBikeDescription(youBikes: youBikeViewModel.youBikes)
            }
    }
}

struct AnnotationItemView_Previews: PreviewProvider {
    static var previews: some View {
        AnnotationItemView(annotationItem: AnnotationItem(name: "工學院", category: AnnotationCategory.building, description: "系所列表\n- 資訊工程學系\n- 電機工程學系\n- 土木與環境工程學系\n- 化學工程及材料工程學系", coordinate: CLLocationCoordinate2D(latitude: 22.732902407964428, longitude: 120.27602509917942)))
            .previewLayout(.sizeThatFits)
            .environmentObject(MapViewModel())
            .environmentObject(YouBikeViewModel())
    }
}
