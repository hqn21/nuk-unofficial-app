//
//  BroadcastViewModel.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/2/6.
//

import Foundation
import Combine

class BroadcastViewModel: ObservableObject {
    @Published var broadcasts: [Broadcast] = []
    @Published var errorMessage: String? = nil
    let fakeBroadcasts: [Broadcast] = [
        Broadcast(id: 0, title: "【測試公告】這是一個用於讀取中展示的測試公告的標題，為了更好地展示 placeholder 的效果，這個標題需要有一定的長度，才能使 placeholder 的效果更加顯著", author: "作者", url: "https://nukapp.haoquan.me", dateTime: Date()),
        Broadcast(id: 1, title: "【測試公告】這是一個用於讀取中展示的測試公告的標題，為了更好地展示 placeholder 的效果，這個標題需要有一定的長度，才能使 placeholder 的效果更加顯著", author: "作者", url: "https://nukapp.haoquan.me", dateTime: Date()),
        Broadcast(id: 2, title: "【測試公告】這是一個用於讀取中展示的測試公告的標題，為了更好地展示 placeholder 的效果，這個標題需要有一定的長度，才能使 placeholder 的效果更加顯著", author: "作者", url: "https://nukapp.haoquan.me", dateTime: Date()),
        Broadcast(id: 3, title: "【測試公告】這是一個用於讀取中展示的測試公告的標題，為了更好地展示 placeholder 的效果，這個標題需要有一定的長度，才能使 placeholder 的效果更加顯著", author: "作者", url: "https://nukapp.haoquan.me", dateTime: Date()),
        Broadcast(id: 4, title: "【測試公告】這是一個用於讀取中展示的測試公告的標題，為了更好地展示 placeholder 的效果，這個標題需要有一定的長度，才能使 placeholder 的效果更加顯著", author: "作者", url: "https://nukapp.haoquan.me", dateTime: Date()),
        Broadcast(id: 5, title: "【測試公告】這是一個用於讀取中展示的測試公告的標題，為了更好地展示 placeholder 的效果，這個標題需要有一定的長度，才能使 placeholder 的效果更加顯著", author: "作者", url: "https://nukapp.haoquan.me", dateTime: Date()),
    ]
    
    @MainActor
    func getBroadcast() async -> Void {
        do {
            broadcasts = try await APIService.shared.fetch(endpoint: "/broadcast")
            errorMessage = nil
        } catch {
            broadcasts = []
            errorMessage = error.localizedDescription
        }
    }
    
    func isLoading() -> Bool {
        return broadcasts.isEmpty && errorMessage == nil
    }
    
    func getDateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
