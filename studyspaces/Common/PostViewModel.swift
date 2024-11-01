//
//  PostViewModel.swift
//  studyspaces
//
//  Created by dilan on 11/1/24.
//
import Observation

@Observable
class PostViewModel {
    var postAPI: PostAPI = PostAPI()
    var posts: [Post] = []
    
    
    public enum Action {
        case post(String)
        case deletePost(String)
    }
    
    func perform(action: Action){
        switch action {
        case .post(let text):
            postAPI.post(text: text)
        case .deletePost(_):
            return
        }
    }
    
    func fetchPosts() async {
        self.posts = await postAPI.fetchPosts()
    }
}


