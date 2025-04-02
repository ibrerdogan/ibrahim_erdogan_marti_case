//
//  CustomButton.swift
//  ibrahim_erdogan_marti_case
//
//  Created by İbrahim Erdogan on 2.04.2025.
//

import UIKit

class CustomButton: UIButton {
    
    init(title: String, icon: UIImage?, backgroundColor: UIColor) {
        super.init(frame: .zero)
        setupButton(title: title, icon: icon, backgroundColor: backgroundColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(title: String, icon: UIImage?, backgroundColor: UIColor) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = 10
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        if let icon = icon {
            self.setImage(icon.withRenderingMode(.alwaysTemplate), for: .normal)
            self.tintColor = .white
            self.imageView?.contentMode = .scaleAspectFit
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        }
    }
}

