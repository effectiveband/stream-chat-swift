//
//  ContentView.swift
//  SwiftUIDemoApp
//
//  Created by Igor Rosocha on 2/24/21.
//  Copyright © 2021 Stream.io Inc. All rights reserved.
//

import SwiftUI
import StreamChat
import StreamChatUI

struct ChannelListView: View {
    var channelListController: _ChatChannelListController<NoExtraData>

    init() {
        // Use first demo user for a showcase
        let userCredentials = UserCredentials.builtInUsers[0]

        // Create a token
        let token = try! Token(rawValue: userCredentials.token)

        // Create client
        let config = ChatClientConfig(apiKey: .init(userCredentials.apiKey))
        let client = ChatClient(config: config, tokenProvider: .static(token))

        // Create controller
        channelListController = client.channelListController(query: .init(filter: .containMembers(userIds: [userCredentials.id])))
    }

    var body: some View {
        ChatChannelListItemVCComponent<NoExtraData>(controller: channelListController)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelListView()
    }
}
