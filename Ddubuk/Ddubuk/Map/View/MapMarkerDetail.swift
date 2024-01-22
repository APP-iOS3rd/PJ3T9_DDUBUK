//
//  MapMarkerDetail.swift
//  Ddubuk
//
//  Created by 조민식 on 1/18/24.
//

import SwiftUI
import CoreLocation

struct MapMarkerDetail: View {
    var selectedResult: MyLocation
    
    var body: some View {
        VStack {
            
            HStack {
                Rectangle()
                    .size(CGSize(width: 150, height: 110))
                
                Spacer()
                
                VStack {
                    Text(selectedResult.title)
                        .font(.system(size: 15, weight: .bold))
                    Text(selectedResult.address)
                        .font(.system(size: 10))
                    
                }
            }
            .padding()
            Spacer()
        }
    }
}
