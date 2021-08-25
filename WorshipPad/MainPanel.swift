//
//  MainPanel.swift
//  WorshipPad
//
//  Created by Wook Rhyu on 7/22/21.
//

import UIKit
import AVFoundation
import Cephalopod

class MainPanel: UIViewController {
    
    let AButton             = KeyButton(key: "A")
    let BbButton            = KeyButton(key: "Bb")
    let BButton             = KeyButton(key: "B")
    let CButton             = KeyButton(key: "C")
    let DbButton            = KeyButton(key: "Db")
    let DButton             = KeyButton(key: "D")
    let EbButton            = KeyButton(key: "Eb")
    let EButton             = KeyButton(key: "E")
    let FButton             = KeyButton(key: "F")
    let GbButton            = KeyButton(key: "F#")
    let GButton             = KeyButton(key: "G")
    let AbButton            = KeyButton(key: "Ab")
    
    let firstContainer      = UIStackView()
    let secondContainer     = UIStackView()
    let thirdContainer      = UIStackView()
    let fourthContainer     = UIStackView()
    
    var currentKey:String!
    var currentColored:KeyButton!
    
    var containerArray:[UIStackView] {
        return [self.firstContainer, self.secondContainer, self.thirdContainer, self.fourthContainer]
    }
    
    var keyButtonArray:[KeyButton]{
        return [AButton, BbButton, BButton, CButton, DbButton, DButton, EbButton, EButton, FButton, GbButton, GButton, AbButton]
    }
    
    var player:AVAudioPlayer?
    var cephalopod: Cephalopod?
    var soundPlaying:Bool   = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureContainers()
        configureButtons(firstButton: AButton, secondButton: BbButton, thirdButton: BButton, container: firstContainer)
        configureButtons(firstButton: CButton, secondButton: DbButton, thirdButton: DButton, container: secondContainer)
        configureButtons(firstButton: EbButton, secondButton: EButton, thirdButton: FButton, container: thirdContainer)
        configureButtons(firstButton: GbButton, secondButton: GButton, thirdButton: AbButton, container: fourthContainer)
        configureToggleSound()
    }
    
    func configureContainers (){
        
        for container in containerArray {
            view.addSubview(container)
            container.axis = .horizontal
            container.distribution = .fillEqually
            container.spacing = 5
            container.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let fourthOfHeight = view.bounds.height/4
        let padding:CGFloat = 5
        
        NSLayoutConstraint.activate([
            firstContainer.topAnchor.constraint(equalTo: view.topAnchor),
            firstContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            firstContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            firstContainer.heightAnchor.constraint(equalToConstant: fourthOfHeight),
            
            secondContainer.topAnchor.constraint(equalTo: firstContainer.bottomAnchor, constant: padding),
            secondContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            secondContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            secondContainer.heightAnchor.constraint(equalToConstant: fourthOfHeight),
            
            thirdContainer.topAnchor.constraint(equalTo: secondContainer.bottomAnchor, constant: padding),
            thirdContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            thirdContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            thirdContainer.heightAnchor.constraint(equalToConstant: fourthOfHeight),
            
            fourthContainer.topAnchor.constraint(equalTo: thirdContainer.bottomAnchor, constant: padding),
            fourthContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fourthContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fourthContainer.heightAnchor.constraint(equalToConstant: fourthOfHeight),
        ])
    }
    
    func configureButtons(firstButton: KeyButton, secondButton: KeyButton, thirdButton: KeyButton, container: UIStackView){
        
        var buttonArray:[KeyButton] {
            return [firstButton, secondButton, thirdButton]
        }
        
        for button in buttonArray{
            container.addArrangedSubview(button)
            button.backgroundColor = .white.withAlphaComponent(0.15)
        }
    }
    
    func configureToggleSound(){
        for keyButton in keyButtonArray{
            keyButton.addTarget(self, action: #selector(toggleSound(sender:)), for: .touchUpInside)
        }
    }
    
    func fadeInColor(_ viewToAnimate:UIButton){
        UIButton.animate(withDuration: 3) {
            viewToAnimate.backgroundColor = .white.withAlphaComponent(0.30)
        } completion: { (_) in
            print("done changing color")
        }
    }
    
    func fadeOutColor(_ viewToAnimate:UIButton){
        UIButton.animate(withDuration: 3) {
            viewToAnimate.backgroundColor = .white.withAlphaComponent(0.15)
        } completion: { (_) in
            print("done changing color")
        }
    }
    
    
    
    @objc func toggleSound(sender: Any) {
        
        let button = sender as? KeyButton
        let filename = "note_\(button!.keyString!)"

        if soundPlaying == false { //If no Pad sound is currently playing
            print("On")
            
            guard let path = Bundle.main.path(forResource: filename, ofType:"mp3") else {
                return }
            let url = URL(fileURLWithPath: path)
            
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [.mixWithOthers, .allowAirPlay])
                print("Playback OK")
                try AVAudioSession.sharedInstance().setActive(true)
                print("Session is Active")
                
                self.fadeInColor(button!)
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
                player?.volume = 0
                cephalopod = Cephalopod(player: player!)
                cephalopod?.fadeIn(duration: 3, velocity: 2, onFinished:{ finished in print("finished fading in")})
                soundPlaying = true
                currentKey = button!.keyString!
                currentColored = button!
                
            } catch let error {
                print(error.localizedDescription)
            }
            
        } else if button?.keyString != currentKey{ //If a different Key is selected but sound should still be played
            
            print("turning off current key")
            self.fadeOutColor(currentColored)
            cephalopod = Cephalopod(player: player!)
            cephalopod?.fadeOut(duration: 3, velocity: 2, onFinished: {finished in
                
                print("finished fading out")
                print("turning on new key")
                self.fadeInColor(button!)
                guard let path = Bundle.main.path(forResource: filename, ofType:"mp3") else {
                    return }
                let url = URL(fileURLWithPath: path)
                
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [.mixWithOthers, .allowAirPlay])
                    print("Playback OK")
                    try AVAudioSession.sharedInstance().setActive(true)
                    print("Session is Active")
                    
                    self.player = try AVAudioPlayer(contentsOf: url)
                    self.player?.play()
                    self.player?.volume = 0
                    self.cephalopod = Cephalopod(player: self.player!)
                    self.cephalopod?.fadeIn(duration: 3, velocity: 2, onFinished:{ finished in print("finishe fading in")})
                    self.soundPlaying = true
                    self.currentKey = button!.keyString!
                    self.currentColored = button!
                } catch let error {
                    print(error.localizedDescription)
                }
            })
        }else{ //If same key is selected meaning sound should turn off
            print("Off")
            fadeOutColor(button!)
            cephalopod = Cephalopod(player: player!)
            cephalopod?.fadeOut(duration: 3, velocity: 2, onFinished: {finished in print("finished fading out")})
            soundPlaying = false
        }
    }

}

