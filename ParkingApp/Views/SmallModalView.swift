//
//  SmallModalView.swift
//  ParkingApp
//
//  Created by 이민호 on 11/29/23.
//

import UIKit
import SwiftUI
import SnapKit

class SmallModalView: UIViewController {
    let parking : Parking
    
    lazy var parkingName: UILabel = {
       let name = UILabel()
        name.text = parking.parkingName
        return name
    }()
    
    init(parking: Parking) {
        self.parking = parking
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configlayout()
    }
    
    func configlayout() {
        self.view.addSubview(parkingName)
        
        parkingName.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}

struct SmallModalView_PreView: PreviewProvider {
    static var previews: some View {
        SmallModalView(parking: Parking(parkingCode: "171721", parkingName: "세종로 공영주차장(시)", addr: "종로구 세종로 80-1", parkingType: "", parkingTypeNm: "", operationRule: "", operationRuleNm: "", tel: "", queStatus: "", queStatusNm: "", capacity: 1260, curParking: 175, curParkingTime: "", payYn: "", payNm: "", nightFreeOpen: "", nightFreeOpenNm: "", weekdayBeginTime: "", weekdayEndTime: "", weekendBeginTime: "", weekendEndTime: "", holidayBeginTime: "", holidayEndTime: "", saturdayPayYn: "", saturdayPayNm: "", holidayPayYn: "", holidayPayNm: "", fulltimeMonthly: "", grpParknm: "", rates: 1, timeRate: 1, addRates: 1, addTimeRate: 1, busRates: 1, busTimeRate: 1, busAddRates: 1, busAddTimeRate: 1, dayMaximum: 1, lat: 37.57340269, lng: 126.97588429, shCo: "", shLink: "", shType: "", shEtc: "")).showPreview()
    }
}
