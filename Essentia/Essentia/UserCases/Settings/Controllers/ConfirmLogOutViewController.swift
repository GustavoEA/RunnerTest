//
//  ConfirmLogOutViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 29.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssCore
import EssResources
import EssUI
import EssDI


class ConfirmLogOutViewController: QuestionAlertViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTitles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //DecibelSDK.shared.set(screen: "ConfirmLogOutViewController")
    }
    
    private func applyTitles() {
        imageView.image = (inject() as AppImageProviderInterface).warningIcon
        titleLabel.text = LS("LogOutAction.Title")
        descriptionLabel.text = LS("LogOutAction.Description")
        leftButton.setTitle(LS("LogOutAction.LeftButton"), for: .normal)
        rightButton.setTitle(LS("LogOutAction.RightButton"), for: .normal)
        leftButton.setTitleColor((inject() as AppColorInterface).appDefaultTextColor, for: .normal)
        rightButton.setTitleColor((inject() as AppColorInterface).centeredButtonBackgroudColor, for: .normal)
    }
}
