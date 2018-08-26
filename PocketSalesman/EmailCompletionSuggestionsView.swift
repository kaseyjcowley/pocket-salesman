//
//  EmailAutoComplete.swift
//  PocketSalesman
//
//  Created by Kasey Cowley on 8/24/18.
//  Copyright © 2018 Kasey - Personal. All rights reserved.
//

import Foundation
import UIKit

class EmailCompletionSuggestionsView: UIView {
    
    var suggestionSelectedHandler: ((String) -> Void)?
    var currentValue: String = ""
    
    private var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    private var defaultSuggestions: [UIButton] {
        get {
            return self.mainDomains.map({"@\($0)"}).map(self.createButton)
        }
    }
    
    private let mainDomains  = ["gmail.com", "yahoo.com", "hotmail.com"]
    private let otherDomains = ["outlook.com", "aol.com", "msn.com", "comcast.net", "live.com", "ymail.com"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        backgroundColor = UIColor(red: 249, green: 249, blue: 249)
        
        stackView.frame = bounds
        defaultSuggestions.forEach { (button) in
            stackView.addArrangedSubview(button)
        }
        addSubview(stackView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showSuggestions(for value: String) {
        isHidden = false
        currentValue = value
        
        var suggestions: [UIButton] = [UIButton]()
        
        if value.contains("@") && value.last == "@" {
            // User just pressed the "@" key, update all the buttons to remove the "@" symbol
            // to make completion easier.
            suggestions = defaultSuggestions.map { (button) -> (UIButton) in
                let title = button.title(for: .normal)!
                let index = title.index(after: title.index(of: "@")!)
                button.setTitle(String(title[index...]), for: .normal)
                return button
            }
        } else if value.contains("@") && value.last != "@" {
            // User has started typing the domain. Remove all suggestions and update them
            // with new suggestions based on the new value.
            let domains = mainDomains + otherDomains
            let domainSoFar = value.components(separatedBy: "@").last!
            
            suggestions = domains
                .filter({ $0.contains(domainSoFar) })
                .prefix(3)
                .map(self.createButton)
        } else {
            suggestions = defaultSuggestions
        }
        
        replaceStackViewSubViews(with: suggestions)
    }
    
    func setSuggestionSelectedHandler(handler: @escaping (String) -> Void) {
        suggestionSelectedHandler = handler
    }
    
    private func createButton(using title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(hex: 0x007aff), for: .normal)
        button.sizeToFit()
        button.showsTouchWhenHighlighted = true
        button.addTarget(self, action: #selector(suggestionTapped(sender:)), for: .touchUpInside)
        return button
    }
    
    private func replaceStackViewSubViews(with views: [UIView]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        views.forEach { stackView.addArrangedSubview($0) }
    }
    
    @objc private func suggestionTapped(sender: UIButton) {
        let suggestion = getPartialSuggestion(sender.title(for: .normal)!)
        suggestionSelectedHandler?(suggestion)
    }
    
    private func getPartialSuggestion(_ suggestion: String) -> String {
        if currentValue.contains("@") && currentValue.last != "@" {
            return String(suggestion.drop { currentValue.contains($0) })
        }
        
        return suggestion
    }
    
}
