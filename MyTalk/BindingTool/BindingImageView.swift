//
//  BindingImageView.swift
//  MyTalk
//
//  Created by 박성영 on 18/04/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

class BindingImageView: UIImageView {
    var imageChanged: (UIImage) -> Void = { _ in }
    
    func bind(callBack: @escaping (UIImage) -> Void) {
        imageChanged = callBack
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewDidChange)))
        //addTarget(self, action: #selector(imageViewDidChange), for: .editingChanged)
    }
    
    @objc func imageViewDidChange() {
        guard let image = image else { return }
        imageChanged(image)
    }
}
