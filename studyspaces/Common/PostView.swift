//
//  PostView.swift
//  studyspaces
//
//  Created by dilan on 11/1/24.
//

import SwiftUI
import Combine

struct PostView: View {
    @Bindable var postViewModel: PostViewModel
    @State var text: String = ""
    var body: some View {
        VStack{
            VStack{
                TextField("Enter your post here", text: $text)
            }
            Button("Post This") {
                postViewModel.perform(action: .post(text))
            }
            
            List(postViewModel.posts, id: \.id) { post in
                Text(post.text)
            }.refreshable {
                await postViewModel.fetchPosts()
            }
        }
    }
}

#Preview {
    PostView(postViewModel: PostViewModel())
}
