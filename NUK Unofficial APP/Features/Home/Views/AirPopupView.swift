//
//  AirPopupView.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/2/4.
//

import SwiftUI

struct AirPopupView: View {
    @EnvironmentObject private var viewModel: AirViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            VStack(spacing: 0) {
                Text("空氣品質")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(Color("DARK_GRAY"))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Group {
                    if let air = viewModel.air {
                        Text("\(viewModel.getDateString(date: air.dateTime))")
                    } else {
                        Text("目前無法獲取空氣品質")
                    }
                }
                .font(.system(size: 14))
                .foregroundColor(Color("DARK_GRAY"))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            ZStack {
                Group {
                    if let air = viewModel.air {
                        viewModel.getAirIcon(aqi: air.aqi)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color("YELLOW"))
                    }
                }
                .frame(height: 150)
                VStack(spacing: 10) {
                    HStack(spacing: 5) {
                        Group {
                            if let air = viewModel.air {
                                Text("\(air.aqi)")
                            } else {
                                Text("--")
                            }
                        }
                        .font(.system(size: 14, design: .monospaced))
                        Text("AQI")
                            .font(.system(size: 14, design: .monospaced))
                            .foregroundColor(Color("DARK_GRAY"))
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(Color("TAG_GRAY"))
                            )
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .offset(x: 10)
                    HStack(spacing: 5) {
                        Group {
                            if let air = viewModel.air {
                                Text("\(air.pm2_5.clean)")
                            } else {
                                Text("--")
                            }
                        }
                        .font(.system(size: 14, design: .monospaced))
                        Text("PM2.5")
                            .font(.system(size: 14, design: .monospaced))
                            .foregroundColor(Color("DARK_GRAY"))
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(Color("TAG_GRAY"))
                            )
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    HStack(spacing: 5) {
                        Group {
                            if let air = viewModel.air {
                                Text("\(air.pm10.clean)")
                            } else {
                                Text("--")
                            }
                        }
                        .font(.system(size: 14, design: .monospaced))
                        Text("PM10")
                            .font(.system(size: 14, design: .monospaced))
                            .foregroundColor(Color("DARK_GRAY"))
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(Color("TAG_GRAY"))
                            )
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    HStack(spacing: 5) {
                        Group {
                            if let air = viewModel.air {
                                Text("\(air.so2.clean)")
                            } else {
                                Text("--")
                            }
                        }
                        .font(.system(size: 14, design: .monospaced))
                        Text("SO2")
                            .font(.system(size: 14, design: .monospaced))
                            .foregroundColor(Color("DARK_GRAY"))
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(Color("TAG_GRAY"))
                            )
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .offset(x: 10)
                }
                .frame(width: UIScreen.main.bounds.maxX * 0.22)
                .frame(maxWidth: .infinity, alignment: .leading)
                VStack(spacing: 10) {
                    HStack(spacing: 5) {
                        Text("CO")
                            .font(.system(size: 14, design: .monospaced))
                            .foregroundColor(Color("DARK_GRAY"))
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(Color("TAG_GRAY"))
                            )
                        Group {
                            if let air = viewModel.air {
                                Text("\(air.co.clean)")
                            } else {
                                Text("--")
                            }
                        }
                        .font(.system(size: 14, design: .monospaced))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(x: -10)
                    HStack(spacing: 5) {
                        Text("O3")
                            .font(.system(size: 14, design: .monospaced))
                            .foregroundColor(Color("DARK_GRAY"))
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(Color("TAG_GRAY"))
                            )
                        Group {
                            if let air = viewModel.air {
                                Text("\(air.o3.clean)")
                            } else {
                                Text("--")
                            }
                        }
                        .font(.system(size: 14, design: .monospaced))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack(spacing: 5) {
                        Text("NO2")
                            .font(.system(size: 14, design: .monospaced))
                            .foregroundColor(Color("DARK_GRAY"))
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(Color("TAG_GRAY"))
                            )
                        Group {
                            if let air = viewModel.air {
                                Text("\(air.no2.clean)")
                            } else {
                                Text("--")
                            }
                        }
                        .font(.system(size: 14, design: .monospaced))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack(spacing: 5) {
                        Text("NO")
                            .font(.system(size: 14, design: .monospaced))
                            .foregroundColor(Color("DARK_GRAY"))
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(Color("TAG_GRAY"))
                            )
                        Group {
                            if let air = viewModel.air {
                                Text("\(air.no.clean)")
                            } else {
                                Text("--")
                            }
                        }
                        .font(.system(size: 14, design: .monospaced))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(x: -10)
                }
                .frame(width: UIScreen.main.bounds.maxX * 0.22)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            HStack(alignment: .top, spacing: 0) {
                Text("※ 單位說明：")
                Text("PM2.5(μg/m³)、PM10(μg/m³)、SO2(ppb)、CO(ppm)、O3(ppb)、NO2(ppb)、NO(ppb)")
            }
            .font(.system(size: 12, design: .monospaced))
            .foregroundColor(Color("DARK_GRAY"))
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("WHITE"))
        )
        .padding(15)
    }
}

struct AirPopupView_Previews: PreviewProvider {
    static var previews: some View {
        AirPopupView()
            .previewLayout(.sizeThatFits)
            .environmentObject(AirViewModel())
    }
}
