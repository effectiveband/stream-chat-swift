//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import StreamChat
import UIKit

/// A `UICollectionViewCell` subclass that shows channel information.
/// By default, it carries over layout of `ChatChannelListCollectionViewCell`
public typealias ChatChannelListPlaceholderCollectionViewCell = _ChatChannelListCollectionViewCell<NoExtraData>

/// A `UICollectionViewCell` subclass that shows channel information.
/// By default, it carries over layout of `ChatChannelListCollectionViewCell`
open class _ChatChannelListPlaceholderCollectionViewCell<ExtraData: ExtraDataTypes>: _CollectionViewCell,
    ThemeProvider {
    /// The `ChatChannelListPlaceholderItemView` instance used as content view.
    open private(set) lazy var itemView: _ChatChannelListPlaceholderItemView<ExtraData> = components
        .channelPlaceholderContentView
        .init()
        .withoutAutoresizingMaskConstraints

    override open func setUpLayout() {
        super.setUpLayout()

        contentView.addSubview(itemView)
        itemView.pin(to: self)
    }

    override open func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        let preferredAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)

        let targetSize = CGSize(
            width: layoutAttributes.frame.width,
            height: layoutAttributes.frame.height
        )

        preferredAttributes.frame.size = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )

        return preferredAttributes
    }
}
