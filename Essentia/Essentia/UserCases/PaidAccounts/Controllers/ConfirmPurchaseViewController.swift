//
//  ConfirmPurchaseViewController.swift
//  EssWallet
//
//  Created by Pavlo Boiko on 5/25/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation
import EssentiaNetworkCore
import EssCore
import EssModel
import EssResources
import EssUI
import EssDI


public class ConfirmPurchaseViewController: BaseBluredTableAdapterController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var interactor: WalletBlockchainWrapperInteractorInterface = inject()
    
    private var wallet: ViewWalletInterface
    private var tx: EtherTxInfo
    private var completeCallback: () -> Void
    
    public init(_ wallet: ViewWalletInterface, tx: EtherTxInfo, completeCallback: @escaping () -> Void) {
        self.wallet = wallet
        self.completeCallback = completeCallback
        self.tx = tx
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //DecibelSDK.shared.set(screen: "ConfirmPurchaseViewController")
    }
    
    override public var state: [TableComponent] {
        return
            [.centeredComponentTopInstet,
             .container(state: containerState)]
    }
    
    private var containerState: [TableComponent] {
        return [
            .empty(height: 10, background: .clear),
            .titleWithFontAligment(font: AppFont.bold.withSize(17), title: LS("PaidAccount.Confirm.Title"), aligment: .center, color: colorProvider.appTitleColor),
            .descriptionWithSize(aligment: .left, fontSize: 14, title: LS("PaidAccount.Confirm.From"), background: .clear, textColor: colorProvider.appDefaultTextColor),
            .descriptionWithSize(aligment: .left, fontSize: 13, title: wallet.name, background: .clear, textColor: colorProvider.titleColor),
            .empty(height: 5, background: .clear),
            .descriptionWithSize(aligment: .left, fontSize: 14, title: LS("PaidAccount.Confirm.To"), background: .clear, textColor: colorProvider.appDefaultTextColor),
            .descriptionWithSize(aligment: .left, fontSize: 12.5, title: tx.address, background: .clear, textColor: colorProvider.titleColor),
            .descriptionWithSize(aligment: .left, fontSize: 14, title: LS("PaidAccount.Confirm.AmmountToSend"), background: .clear, textColor: colorProvider.appDefaultTextColor),
            .descriptionWithSize(aligment: .left, fontSize: 13, title: formattedTransactionAmmount(), background: .clear, textColor: colorProvider.titleColor),
            .empty(height: 10, background: .clear),
            .separator(inset: .zero),
            .twoButtons(lTitle: LS("PaidAccount.Confirm.Cancel"),
                        rTitle: LS("PaidAccount.Confirm.Pay"),
                        lColor: colorProvider.appDefaultTextColor,
                        rColor: colorProvider.centeredButtonBackgroudColor,
                        lAction: cancelAction,
                        rAction: confirmAction),
            .empty(height: 10, background: .clear)
        ]
    }
    
    private func formattedTransactionAmmount() -> String {
        let cryptoFormatter = BalanceFormatter(asset: wallet.asset)
        return cryptoFormatter.formattedAmmountWithCurrency(amount: tx.ammount.inCrypto)
    }
    
    // MARK: - Actions
    private lazy var  cancelAction: () -> Void = { [unowned self] in
        self.dismiss(animated: true)
    }
    
    private lazy var confirmAction: () -> Void = { [unowned self] in
        (inject() as LoaderInterface).show()
        do {
            try self.interactor.sendEthTransaction(wallet: self.wallet, transacionDetial: self.tx, result: self.responceTransaction)
        } catch {
            self.showInfo(error.localizedDescription, type: .error)
        }
    }
    
    private lazy var responceTransaction: (NetworkResult<String>) -> Void = { [unowned self] in
        (inject() as LoaderInterface).hide()
        switch $0 {
        case .success(let object):
            (inject() as LoggerServiceInterface).log(object)
            UserDefaults.standard.setValue(self.wallet.address, forKey: EssDefault.purchaseAddress.rawValue)
            self.dismiss(animated: true)
            self.completeCallback()
        case .failure(let error):
            self.dismiss(animated: true, completion: {
                (inject() as LoaderInterface).showError(error.localizedDescription)
            })
        }
    }
}
