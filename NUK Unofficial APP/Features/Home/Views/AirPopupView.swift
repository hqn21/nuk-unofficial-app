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
                Text("home.air.title.long")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(Color("DARK_GRAY"))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Group {
                    if let air = viewModel.air {
                        Text(verbatim: "\(viewModel.getDateString(date: air.dateTime))")
                    } else {
                        Text("home.air.error")
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
                                Text(verbatim: "\(air.aqi)")
                            } else {
                                Text(verbatim: "--")
                            }
                        }
                        .font(.system(size: 14, design: .monospaced))
                        Text(verbatim: "AQI")
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
                                Text(verbatim: "\(air.pm2_5.clean)")
                            } else {
                                Text(verbatim: "--")
                            }
                        }
                        .font(.system(size: 14, design: .monospaced))
                        Text(verbatim: "PM2.5")
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
                                Text(verbatim: "\(air.pm10.clean)")
                            } else {
                                Text(verbatim: "--")
                            }
                        }
                        .font(.system(size: 14, design: .monospaced))
                        Text(verbatim: "PM10")
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
                                Text(verbatim: "\(air.so2.clean)")
                            } else {
                                Text(verbatim: "--")
                            }
                        }
                        .font(.system(size: 14, design: .monospaced))
                        Text(verbatim: "SO2")
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
                        Text(verbatim: "CO")
                            .font(.system(size: 14, design: .monospaced))
                            .foregroundColor(Color("DARK_GRAY"))
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(Color("TAG_GRAY"))
                            )
                        Group {
                            if let air = viewModel.air {
                                Text(verbatim: "\(air.co.clean)")
                            } else {
                                Text(verbatim: "--")
                            }
                        }
                        .font(.system(size: 14, design: .monospaced))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(x: -10)
                    HStack(spacing: 5) {
                        Text(verbatim: "O3")
                            .font(.system(size: 14, design: .monospaced))
                            .foregroundColor(Color("DARK_GRAY"))
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(Color("TAG_GRAY"))
                            )
                        Group {
                            if let air = viewModel.air {
                                Text(verbatim: "\(air.o3.clean)")
                            } else {
                                Text(verbatim: "--")
                            }
                        }
                        .font(.system(size: 14, design: .monospaced))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack(spacing: 5) {
                        Text(verbatim: "NO2")
                            .font(.system(size: 14, design: .monospaced))
                            .foregroundColor(Color("DARK_GRAY"))
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(Color("TAG_GRAY"))
                            )
                        Group {
                            if let air = viewModel.air {
                                Text(verbatim: "\(air.no2.clean)")
                            } else {
                                Text(verbatim: "--")
                            }
                        }
                        .font(.system(size: 14, design: .monospaced))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack(spacing: 5) {
                        Text(verbatim: "NO")
                            .font(.system(size: 14, design: .monospaced))
                            .foregroundColor(Color("DARK_GRAY"))
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(Color("TAG_GRAY"))
                            )
                        Group {
                            if let air = viewModel.air {
                                Text(verbatim: "\(air.no.clean)")
                            } else {
                                Text(verbatim: "--")
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
                Text(verbatim: "※ \(String(localized: "home.air.unit"))：")
                Text(verbatim: "PM2.5(μg/m³)、PM10(μg/m³)、SO2(ppb)、CO(ppm)、O3(ppb)、NO2(ppb)、NO(ppb)")
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
