//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import StreamChat
import UIKit

/// An `UIView` subclass that shows placeholder for `ChatChannelListItemView`.
/// By default, it carries over layout of `ChatChannelListItemView`
open class ChatChannelListPlaceholderItemView: _View, ThemeProvider, SwiftUIRepresentable {
    /// The data this view component shows.
    public var content: String? {
        didSet { updateContentIfNeeded() }
    }
    
    public var skeletons: [UIView] {
        [timestampLabel, titleLabel, subtitleLabel, avatarView]
    }

    /// The date formatter of the `timestampLabel`
    public lazy var dateFormatter: DateFormatter = .makeDefault()

    /// Main container which holds `avatarView` and two horizontal containers `title` and `unreadCount` and
    /// `subtitle` and `timestampLabel`
    open private(set) lazy var mainContainer: ContainerStackView = ContainerStackView().withoutAutoresizingMaskConstraints

    /// By default contains `title` and `unreadCount`.
    /// This container is embed inside `mainContainer ` and is the one above `bottomContainer`
    open private(set) lazy var topContainer: ContainerStackView = ContainerStackView().withoutAutoresizingMaskConstraints

    /// By default contains `subtitle` and `timestampLabel`.
    /// This container is embed inside `mainContainer ` and is the one below `topContainer`
    open private(set) lazy var bottomContainer: ContainerStackView = ContainerStackView().withoutAutoresizingMaskConstraints
    
    /// The `UILabel` instance showing the channel name.
    open private(set) lazy var titleLabel: UILabel = UILabel()
        .withoutAutoresizingMaskConstraints
        .withAdjustingFontForContentSizeCategory
        .withBidirectionalLanguagesSupport
    
    /// The `UILabel` instance showing the last message or typing users if any.
    open private(set) lazy var subtitleLabel: UILabel = UILabel()
        .withoutAutoresizingMaskConstraints
        .withAdjustingFontForContentSizeCategory
        .withBidirectionalLanguagesSupport
    
    /// The `UILabel` instance showing the time of the last sent message.
    open private(set) lazy var timestampLabel: UILabel = UILabel()
        .withoutAutoresizingMaskConstraints
        .withAdjustingFontForContentSizeCategory
        .withBidirectionalLanguagesSupport
    
    /// The view used to show channels avatar.
    open private(set) lazy var avatarView: UIView = UIView().withoutAutoresizingMaskConstraints
    
    /// The view showing number of unread messages in channel if any.
    open private(set) lazy var unreadCountView: ChatChannelUnreadCountView = components
        .channelUnreadCountView.init()
        .withoutAutoresizingMaskConstraints

    /// Text of `titleLabel` which contains the channel name.
    open var titleText: String = "Title text"

    /// Text of `subtitleLabel` which contains current typing user or the last message in the channel.
    open var subtitleText: String = "Subtitle text"

    /// Text of `timestampLabel` which contains the time of the last sent message.
    open var timestampText: String = "9:41"
    
    open var gradientAnimatableLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.red.cgColor,
            UIColor.yellow.cgColor,
            UIColor.green.cgColor,
            UIColor.blue.cgColor
        ]
        layer.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1)
        layer.frame = .init(x: 0, y: 0, width: 400, height: 400)
        return layer
    }()

    override open func setUpAppearance() {
        super.setUpAppearance()
        backgroundColor = appearance.colorPalette.background
    }

    override open func setUpLayout() {
        super.setUpLayout()

        /// Default layout:
        /// ```
        /// |----------------------------------------------------|
        /// |            | titleLabel          | unreadCountView |
        /// | avatarView | --------------------------------------|
        /// |            | subtitleLabel        | timestampLabel |
        /// |----------------------------------------------------|
        /// ```
        
        topContainer.addArrangedSubviews([
            titleLabel.flexible(axis: .horizontal), unreadCountView
        ])

        bottomContainer.addArrangedSubviews([
            subtitleLabel.flexible(axis: .horizontal), timestampLabel
        ])

        NSLayoutConstraint.activate([
            avatarView.heightAnchor.pin(equalToConstant: 48),
            avatarView.widthAnchor.pin(equalTo: avatarView.heightAnchor)
        ])

        mainContainer.addArrangedSubviews([
            avatarView,
            ContainerStackView(
                axis: .vertical,
                spacing: 4,
                arrangedSubviews: [topContainer, bottomContainer]
            )
        ])
        
        mainContainer.alignment = .center
        mainContainer.isLayoutMarginsRelativeArrangement = true
        
        embed(mainContainer)
    }
    
    override open func updateContent() {
        // Safe to call this in here, it's called just once because on skeleton really nothing to change.
        super.updateContent()
        
        titleLabel.text = titleText
        subtitleLabel.text = subtitleText
        timestampLabel.text = timestampText
        
        skeletons.forEach {
            let skeleton = SkeletonView().withoutAutoresizingMaskConstraints
            $0.embed(skeleton)
            skeleton.setup(with: $0, maskingView: self)
        }
    }
}
