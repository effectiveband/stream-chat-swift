//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import StreamChat
import UIKit

/// View responsible for displaying loading indicator for ChannelListVC.
typealias ChatChannelListLoadingView = _ChatChannelListLoadingView<NoExtraData>
/// View responsible for displaying loading indicator for ChannelListVC.
open class _ChatChannelListLoadingView<ExtraData: ExtraDataTypes>: _View, ThemeProvider, UICollectionViewDelegate,
    UICollectionViewDataSource {
    /// The `UICollectionViewLayout` that used by `ChatChannelListCollectionView`.
    open private(set) lazy var collectionViewLayout: UICollectionViewLayout = components
        .channelListLayout.init()
    
    /// The `UICollectionView` instance that displays skeleton channel list.
    open private(set) lazy var collectionView: UICollectionView =
        UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
            .withoutAutoresizingMaskConstraints
    
    /// Reuse identifier of `collectionViewCell`
    open var collectionViewCellReuseIdentifier: String { "PlaceHolderCell" }
    
    /// Reuse identifier of separator
    open var separatorReuseIdentifier: String { "CellSeparatorIdentifier" }
    
    override open func setUpLayout() {
        super.setUpLayout()
        addSubview(collectionView)
        collectionView.pin(to: self)
    }
    
    override open func setUpAppearance() {
        super.setUpAppearance()
        
        collectionView.backgroundColor = appearance.colorPalette.background

        if let flowLayout = collectionViewLayout as? ListCollectionViewLayout {
            flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.estimatedItemSize = .init(
                width: collectionView.bounds.width,
                height: 64
            )
        }
    }

    override open func setUp() {
        super.setUp()
        collectionView.isUserInteractionEnabled = false
        collectionView.register(
            components.channelPlaceholderCell.self,
            forCellWithReuseIdentifier: collectionViewCellReuseIdentifier
        )
        
        collectionView.register(
            components.channelCellSeparator,
            forSupplementaryViewOfKind: ListCollectionViewLayout.separatorKind,
            withReuseIdentifier: separatorReuseIdentifier
        )
        collectionView.dataSource = self
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        14
    }
    
    open func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        collectionView.dequeueReusableSupplementaryView(
            ofKind: ListCollectionViewLayout.separatorKind,
            withReuseIdentifier: separatorReuseIdentifier,
            for: indexPath
        )
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: collectionViewCellReuseIdentifier,
            for: indexPath
        ) as! _ChatChannelListPlaceholderCollectionViewCell<ExtraData>
    
        cell.components = components
        return cell
    }
    
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        collectionViewLayout.invalidateLayout()
    }
}
