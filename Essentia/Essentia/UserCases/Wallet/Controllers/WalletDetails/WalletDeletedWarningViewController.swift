//
//  WalletDeletedWarningViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12/5/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssCore
import EssModel
import EssUI
import EssResources


class WalletDeletedWarningViewController: InfoAlertViewController {
    private var walletName: String
    
    init(walletName: String, okAction: @escaping () -> Void) {
        self.walletName = walletName
        super.init(okAction: okAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTitles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //DecibelSDK.shared.set(screen: "WalletDeletedWarningViewController")
    }
    
    private func applyTitles() {
        // MARK: - LocalizedStrings
        okButton.setTitle(LS("Wallet.Deleted.Button"), for: .normal)
        titleLabel.text = LS("Wallet.Deleted.Title")
        let description = LS("Wallet.Deleted.Description1") + walletName + LS("Wallet.Deleted.Description2")
        descriptionLabel.text = description
        
        checkImageView.image = imageProvider.checkInfoIcon
    }
}
