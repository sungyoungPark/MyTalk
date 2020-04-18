//
//  BindingTextField.swift
//  MyTalk
//
//  Created by 박성영 on 18/04/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

class BindingTextField: UITextField {
    var textChanged: (String) -> Void = { _ in }
    
    func bind(callBack: @escaping (String) -> Void) {
        textChanged = callBack
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let text = text else { return }
        textChanged(text)
    }
}
