//
//  ViewController.swift
//  vmpankratov@PW1
//
//  Created by Tom Tim on 15.10.2024.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var views: [UIView]!
    @IBOutlet weak var button: UIButton!
    
    // MARK: - State
    private var isExpanded = false
    
    // MARK: - Constants
    private let animationDuration: TimeInterval = 1.0
    private let initialWidth: CGFloat = 60
    private let viewHeight: CGFloat = 50.0
    private let buttonHeight: CGFloat = 50.0
    private let buttonWidthMultiplier: Double = 0.5
    private let viewVerticalSpacing: CGFloat = 10
    private let initialYPositionOffset: CGFloat = 100
    private let maxCornerRadius: CGFloat = 25.0
    
    private var fullWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        arrangeViewsVertically()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func arrangeViewsVertically() {
        var colors = UIColor.getUniqueColors(views.count)
        
        for (index, view) in views.enumerated() {
            view.backgroundColor = colors.removeFirst()
            view.layer.cornerRadius = .random(in: 0...self.maxCornerRadius)
            let isRightAligned = index % 2 == 0
            let offset = isRightAligned ? (fullWidth - initialWidth) : 0
            
            view.frame = CGRect(
                x: offset,
                y: CGFloat(index) * (viewHeight + viewVerticalSpacing) + initialYPositionOffset,
                width: initialWidth,
                height: viewHeight
            )
            view.layer.cornerRadius = 5
        }
        
        button.pinCenterX(to: self.view)
        button.pinTop(to: views.last!.bottomAnchor, 20)
        button.setWidth(buttonWidthMultiplier * Double(self.view.frame.width))
        button.setHeight(buttonHeight)
        button.setTitle("Жми", for: UIControl.State.normal)
    }
    
    // MARK: - IBAction
    @IBAction func buttonWasPressed(_ sender: UIButton) {
        var colors = UIColor.getUniqueColors(views.count)
        
        self.button.isEnabled = false
        self.button.setTitle("Не жми", for: UIControl.State.normal)

        UIView.animate(withDuration: self.animationDuration, animations: {
            for view in self.views {
                view.frame.size.width = self.fullWidth
            }
        }) { _ in
            UIView.animate(withDuration: self.animationDuration, animations: {
                for (index, view) in self.views.enumerated() {
                    view.backgroundColor = colors.removeFirst()
                    view.layer.cornerRadius = .random(in: 0...self.maxCornerRadius)
                    view.frame.size.width = self.initialWidth
                    var isRightAligned = index % 2 == 0
                    if self.isExpanded {
                        isRightAligned = index % 2 != 0
                    }
                    let offset = isRightAligned ? 0 : (self.fullWidth - self.initialWidth)
                    view.frame.origin.x = offset
                }
                
                self.isExpanded.toggle()
            }) { _ in
                self.button.isEnabled = true
                self.button.setTitle("Жми", for: UIControl.State.normal)
            }
        }
    }
}

// MARK: - UIColor extension
extension UIColor {
    // MARK: - Hex letters
    enum hexLetters: String, CaseIterable {
        case A, B, C, D, E, F
        case one = "1", two = "2", three = "3", four = "4", five = "5"
        case six = "6", seven = "7", eight = "8", nine = "9", zero = "0"
    }
    
    // MARK: - Initializer from hex
    convenience init?(hex: String) {
        var newHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        newHex = newHex.uppercased()
        
        if newHex.hasPrefix("#") {
            newHex.removeFirst()
        }
        
        if newHex.count != 6 {
            return nil
        }
        
        var rgb: UInt64 = 0
        
        Scanner(string: newHex).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255
        let green = Double((rgb & 0x00FF00) >> 8) / 255
        let blue = Double(rgb & 0x0000FF) / 255
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    // MARK: - Get Unique Colors
    static func getUniqueColors(_ count: Int) -> [UIColor] {
        var setColors: Set<UIColor> = []
        while setColors.count < count {
            let randomColor = UIColor.random()
            setColors.insert(randomColor)
        }
        return Array(setColors)
    }
    
    // MARK: - Get random color
    static func random() -> UIColor {
        let hex = randomHEXColor()
        return UIColor(hex: hex) ?? UIColor.white
    }
    
    // MARK: - Get random hex color
    static func randomHEXColor() -> String {
        var hex = "#"
        for _ in 0..<6 {
            hex.append(hexLetters.allCases.randomElement()!.rawValue)
        }
        return hex
    }
}
