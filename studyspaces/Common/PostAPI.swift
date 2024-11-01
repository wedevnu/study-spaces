//
//  PostAPI.swift
//  studyspaces
//
//  Created by dilan on 11/1/24.
//


class PostAPI {
    var idCounter = 0
    var posts: [Post] = [Post(id: -1, text: "Hello WeDev")]
    
    func fetchPosts() async -> [Post] {
        return self.posts
    }
    
    func post(text: String) {
        posts.append(Post(id: idCounter, text: text))
        idCounter += 1
    }
    
}
