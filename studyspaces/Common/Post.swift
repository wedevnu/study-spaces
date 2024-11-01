//
//  Post.swift
//  studyspaces
//
//  Created by dilan on 11/1/24.
//

import Observation

@Observable
class Post {
    var id: Int
    var text: String
    
    init(id: Int, text: String) {
        self.id = id
        self.text = text
    }
}
