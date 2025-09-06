//
//  MapViewModel.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/2/7.
//

import Foundation
import SwiftUI
import MapKit

class MapViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 22.733164, longitude: 120.284257),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    @Published var focusAnnotationItem: AnnotationItem? = nil
    @Published var showSheet: Bool = false
    @Published var userLocation: CLLocationCoordinate2D? = nil
    @Published var errorMessage: String? = nil
    @Published var annotationItems: [AnnotationItem] = [
        AnnotationItem(name: "活動中心", category: AnnotationCategory.youBike, description: "正在取得站點資訊", coordinate: CLLocationCoordinate2D(latitude: 22.7324227216491, longitude: 120.28049640646954)),
        AnnotationItem(name: "行政大樓", category: AnnotationCategory.youBike, description: "正在取得站點資訊", coordinate: CLLocationCoordinate2D(latitude: 22.734690354796783, longitude: 120.28345207298692)),
        AnnotationItem(name: "管理學院", category: AnnotationCategory.youBike, description: "正在取得站點資訊", coordinate: CLLocationCoordinate2D(latitude: 22.73312816246225, longitude: 120.28754521172304)),
        AnnotationItem(name: "理學院南側", category: AnnotationCategory.youBike, description: "正在取得站點資訊", coordinate: CLLocationCoordinate2D(latitude: 22.735181120576712, longitude: 120.28590856167096)),
        AnnotationItem(name: "社科院西側", category: AnnotationCategory.youBike, description: "正在取得站點資訊", coordinate: CLLocationCoordinate2D(latitude: 22.73594559963605, longitude: 120.28087799353618)),
        AnnotationItem(name: "第一宿舍東側", category: AnnotationCategory.youBike, description: "正在取得站點資訊", coordinate: CLLocationCoordinate2D(latitude: 22.735837760271927, longitude: 120.27799153440107)),
        AnnotationItem(name: "校門口", category: AnnotationCategory.youBike, description: "正在取得站點資訊", coordinate: CLLocationCoordinate2D(latitude: 22.732675594009088, longitude: 120.28426210914056)),
        AnnotationItem(name: "大學南路側", category: AnnotationCategory.youBike, description: "正在取得站點資訊", coordinate: CLLocationCoordinate2D(latitude: 22.732600358698647, longitude: 120.28986015349126)),
        AnnotationItem(name: "大學西路側", category: AnnotationCategory.youBike, description: "正在取得站點資訊", coordinate: CLLocationCoordinate2D(latitude: 22.732098174462138, longitude: 120.27641585465034)),
        AnnotationItem(name: "第一綜合大樓", category: AnnotationCategory.youBike, description: "正在取得站點資訊", coordinate: CLLocationCoordinate2D(latitude: 22.730232594574066, longitude: 120.27848689865901)),

        AnnotationItem(name: "工學院", category: AnnotationCategory.building, description: "系所列表\n- 資訊工程學系\n- 電機工程學系\n- 土木與環境工程學系\n- 化學工程及材料工程學系", coordinate: CLLocationCoordinate2D(latitude: 22.732902407964428, longitude: 120.27602509917942)),
        AnnotationItem(name: "理學院", category: AnnotationCategory.building, description: "系所列表\n- 應用數學系\n- 應用化學系\n- 生命科學系\n- 應用物理學系", coordinate: CLLocationCoordinate2D(latitude: 22.735876507693284, longitude: 120.285828654822)),
        AnnotationItem(name: "法學院", category: AnnotationCategory.building, description: "系所列表\n- 法律學系\n- 政治法律學系\n- 財經法律學系", coordinate: CLLocationCoordinate2D(latitude: 22.732791385204816, longitude: 120.28725775852074)),
        AnnotationItem(name: "管理學院", category: AnnotationCategory.building, description: "系所列表\n- 資訊管理學系\n- 金融管理學系\n- 應用經濟學系\n- 亞太工商管理學系", coordinate: CLLocationCoordinate2D(latitude: 22.732766572351494, longitude: 120.28776554758544)),
        AnnotationItem(name: "人文社會科學院", category: AnnotationCategory.building, description: "系所列表\n- 建築學系\n- 西洋語文學系\n- 東亞語文學系\n- 運動競技學系\n- 運動健康與休閒學系\n- 工藝與創意設計學系", coordinate: CLLocationCoordinate2D(latitude: 22.735809777956923, longitude: 120.28141149678787)),
        AnnotationItem(name: "圖書資訊大樓", category: AnnotationCategory.building, description: "場所介紹\n- 圖書館\n- 宅創空間\n- EMBA中心", coordinate: CLLocationCoordinate2D(latitude: 22.734328907131445, longitude: 120.28521417879298)),
        AnnotationItem(name: "體育健康休閒大樓", category: AnnotationCategory.building, description: "場所介紹\n- 游泳池\n- 羽球場\n- 壁球室\n- 健身房", coordinate: CLLocationCoordinate2D(latitude: 22.73435630331275, longitude: 120.27807205846327)),
        AnnotationItem(name: "綜合第一大樓", category: AnnotationCategory.building, description: "場所介紹\n- 語文中心\n- 綜合宿舍（男宿）", coordinate: CLLocationCoordinate2D(latitude: 22.731365140403806, longitude: 120.27722837957475)),
        AnnotationItem(name: "第一宿舍", category: AnnotationCategory.dorm, description: "宿舍配置\n- 男宿\n- 女宿", coordinate: CLLocationCoordinate2D(latitude: 22.73555185078744, longitude: 120.27836156059486)),
        AnnotationItem(name: "第二宿舍", category: AnnotationCategory.dorm, description: "宿舍配置\n- 男宿\n- 女宿", coordinate: CLLocationCoordinate2D(latitude: 22.73582582923408, longitude: 120.27851371367713))
    ]
    private var locationManager: CLLocationManager? = nil
    
    private func evaluateAuthorizationStatus() {
        guard let locationManager = locationManager else {
            return
        }

        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            DispatchQueue.main.async {
                self.userLocation = locationManager.location?.coordinate
            }
        @unknown default:
            break
        }
    }
    
    func initLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        evaluateAuthorizationStatus()
    }
    
    func isFocus(annotationItem: AnnotationItem) -> Bool {
        if focusAnnotationItem == nil {
            return false
        }
        return focusAnnotationItem!.id == annotationItem.id
    }
    
    @MainActor
    func setFocus(annotationItem: AnnotationItem) {
        focusAnnotationItem = annotationItem
        showSheet = true
        setMapCenter(coordinate: annotationItem.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    }
    
    @MainActor
    func resetFocus() {
        focusAnnotationItem = nil
        showSheet = false
    }
    
    @MainActor
    func resetMapCenter() {
        withAnimation(.easeInOut) {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 22.733164, longitude: 120.284257),
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
        }
    }
    
    @MainActor
    func setUserLocationAsMapCenter() -> Bool {
        if let userLocation = userLocation {
            errorMessage = nil
            withAnimation(.easeInOut) {
                region = MKCoordinateRegion(
                    center: userLocation,
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                )
            }
            return true
        }
        errorMessage = "您尚未允許定位功能，請至設定中調整，謝謝"
        return false
    }
    
    @MainActor
    func setMapCenter(coordinate: CLLocationCoordinate2D, span: MKCoordinateSpan) {
        withAnimation(.easeInOut) {
            region = MKCoordinateRegion(
                center: coordinate,
                span: span
            )
        }
    }
    
    @MainActor
    func setYouBikeDescription(youBikes: [YouBike]) {
        for i in annotationItems.indices {
            if annotationItems[i].category == AnnotationCategory.youBike {
                for youBike in youBikes {
                    if annotationItems[i].name == youBike.name {
                        annotationItems[i].description = "車位狀態\n- \(youBike.availableSpace) 輛可借\n- \(youBike.parkingSpace) 輛可停"
                    }
                }
            }
        }
    }
}
