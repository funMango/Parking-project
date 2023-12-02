//
//  ActionButton.swift
//  ParkingApp
//
//  Created by 이민호 on 12/2/23.
//

import UIKit

class RefreshButton: UIButton {
    private var action: (() -> Void)?
    var config = UIButton.Configuration.filled()
    var titleContainer = AttributeContainer()

    init(title: String, action: @escaping () -> Void) {
        super.init(frame: .zero)
        configure()
        self.configuration = self.config
        self.action = action
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func configure() {
        titleContainer.font = UIFont.boldSystemFont(ofSize: 20)
        self.config.attributedTitle = AttributedString("refresh", attributes: titleContainer)
        self.config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 15)
        self.config.imagePadding = 10
        self.config.titlePadding = 3
        self.config.title = "현 위치에서 새로고침"
        self.config.image = UIImage(systemName: "arrow.clockwise")
    }

    @objc private func buttonTapped() {
        action?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


