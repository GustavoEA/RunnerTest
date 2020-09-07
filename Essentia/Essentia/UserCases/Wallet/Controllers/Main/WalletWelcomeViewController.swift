//
//  WalletWelcomeViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssResources
import EssUI
import EssDI


class WalletWelcomeViewController: BaseTableAdapterController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private var currentPosition = 1
    private var leftSwipeRecognizer: UISwipeGestureRecognizer!
    private var rightSwipeRecognizer: UISwipeGestureRecognizer!
    
    override init() {
        super.init()
        leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.leftSwipeGesture(gesture:)))
        leftSwipeRecognizer.direction = .left
        rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.rightSwipeGesture(gesture:)))
        rightSwipeRecognizer.direction = .right
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        applyDesign()
        addRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //DecibelSDK.shared.set(screen: "WalletWelcomeViewController")
    }
    
    // MARK: - State
    override var state: [TableComponent] {
        let currentImage = AppImageProvider.image(name: "walletOnbording\(currentPosition)")
        return [
            .calculatbleSpace(background: .clear),
            .centeredImage(image: currentImage),
            .empty(height: 45, background: .clear),
            .titleWithFontAligment(font: AppFont.bold.withSize(32), title: LS("Wallet.Onbording\(currentPosition).Title"), aligment: .center, color: colorProvider.appBackgroundColor),
            .descriptionWithSize(aligment: .center,
                                 fontSize: 15,
                                 title: LS("Wallet.Onbording\(currentPosition).Detail"),
                                 background: .clear,
                                 textColor: colorProvider.appBackgroundColor),
            .empty(height: 30, background: .clear),
            .pageControl(count: 3, selected: currentPosition - 1 ),
            .empty(height: 30, background: .clear),
            .actionCenteredButton(title: LS("Wallet.Welcome.Continue"),
                                  action: continueAction,
                                  textColor: colorProvider.appTitleColor,
                                  backgrount: colorProvider.appBackgroundColor),
            .empty(height: 16, background: .clear)
        ]
    }

    private func applyDesign() {
        self.tableView.backgroundColor = colorForCurrentSegment()
    }
    
    private func addRecognizer() {
        tableView.addGestureRecognizer(leftSwipeRecognizer)
        tableView.addGestureRecognizer(rightSwipeRecognizer)
    }
    
    @objc func leftSwipeGesture(gesture: UISwipeGestureRecognizer) {
        guard currentPosition != 3 else { return }
        currentPosition++
        self.tableAdapter.performTableUpdate(newState: state, withAnimation: .toRight)
        animateBackground()
    }
    
    @objc func rightSwipeGesture(gesture: UISwipeGestureRecognizer) {
        guard currentPosition != 1 else { return }
        currentPosition--
        self.tableAdapter.performTableUpdate(newState: state, withAnimation: .toLeft)
        animateBackground()
    }
    
    private func animateBackground() {
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            self.tableView.backgroundColor = self.colorForCurrentSegment()
        })
    }
    
    private func colorForCurrentSegment() -> UIColor {
        switch currentPosition {
        case 1:
            return colorProvider.accountStrengthContainerViewBackgroudHightSecure
        case 2:
            return colorProvider.persianBlueColor
        case 3:
            return colorProvider.summerSkyColor
        default:
            return colorProvider.appBackgroundColor
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Actions
    private lazy var continueAction: () -> Void = { [unowned self] in
        switch self.currentPosition {
        case 3:
            self.dismiss(animated: true)
        default:
            self.leftSwipeGesture(gesture: self.leftSwipeRecognizer)
        }
    }
}
