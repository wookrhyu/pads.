//
//  KeyButton.swift
//  WorshipPad
//
//  Created by Wook Rhyu on 7/22/21.
//

import UIKit

class KeyButton: UIButton {

    var keyString: String?
    let buttonContainer = UIView()
    let keyLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        //configurebuttonContainer()
        configureButtonAttributes()
        configureKeyLabel()
    }
    
    convenience init(key:String) {
        self.init(frame: .zero)
        self.keyString = key
        self.keyLabel.text = key
    }
    
    func configureKeyLabel() {
        self.addSubview(keyLabel)
        keyLabel.translatesAutoresizingMaskIntoConstraints = false
        keyLabel.textColor = .white.withAlphaComponent(0.5)
        keyLabel.font = UIFont(name: "Futura-Medium", size: 20)
        
        NSLayoutConstraint.activate([
            keyLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            keyLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func configureButtonAttributes() {
    
    }
    
    func configurebuttonContainer() {
        self.addSubview(buttonContainer)
        buttonContainer.backgroundColor = .cyan
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let padding:CGFloat = 5
        
        NSLayoutConstraint.activate([
            buttonContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            buttonContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: padding),
            buttonContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            buttonContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: padding)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
