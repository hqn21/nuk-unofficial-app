//
//  MapSheetView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/2/7.
//

import SwiftUI
import MapKit

struct MapSheetView: View {
    @EnvironmentObject private var youBikeViewModel: YouBikeViewModel
    @State private var showErrorAlert: Bool = false
    let annotationItem: AnnotationItem
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .top, spacing: 0) {
                VStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(verbatim: "\(annotationItem.name)")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(Color("DARK_GRAY"))
                        HStack(spacing: 5) {
                            Image("\(annotationItem.category.rawValue)")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 16)
                            Text("\(annotationItem.category.fullName)")
                                .font(.system(size: 16))
                                .fontWeight(.semibold)
                                .foregroundColor(Color("DARK_GRAY"))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("地點資訊")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(Color("DARK_GRAY"))
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(Color("TAG_GRAY"))
                            )
                        Text("\(annotationItem.description)")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .foregroundColor(Color("DARK_GRAY"))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
                Group {
                    if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
                        Link(destination: URL(string: "comgooglemaps://?saddr=&daddr=\(annotationItem.coordinate.latitude   ),\(annotationItem.coordinate.longitude)&directionsmode=walking")!, label: {
                            HStack(spacing: 5) {
                                Text("導航")
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                Image(systemName: "figure.walk.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 16)
                            }
                            .foregroundColor(Color("WHITE"))
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(Color("YELLOW"))
                            )
                        })
                    } else {
                        Button(action: {
                            showErrorAlert = true
                        }, label: {
                            HStack(spacing: 5) {
                                Text("導航")
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                Image(systemName: "figure.walk.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 16)
                            }
                            .foregroundColor(Color("WHITE"))
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(Color("LITTLE_DARK_GRAY"))
                            )
                        })
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            Divider()
                .frame(width: .infinity)
            Text("資訊內容請以國立高雄大學官網為準")
                .font(.system(size: 14))
                .fontWeight(.regular)
                .foregroundStyle(Color("DARK_GRAY"))
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(20)
        .alert(
            "地圖",
            isPresented: $showErrorAlert,
            actions: {
                Button("確認", action: {})
            },
            message: {
                Text("您沒有安裝 Google Maps，請確認後重新嘗試。")
            }
        )
    }
}

struct MapSheetView_Previews: PreviewProvider {
    static var previews: some View {
        MapSheetView(annotationItem: AnnotationItem(name: "工學院", category: AnnotationCategory.building, description: "系所列表\n- 資訊工程學系\n- 電機工程學系\n- 土木與環境工程學系\n- 化學工程及材料工程學系", coordinate: CLLocationCoordinate2D(latitude: 22.732902407964428, longitude: 120.27602509917942)))
            .previewLayout(.sizeThatFits)
            .environmentObject(YouBikeViewModel())
    }
}
