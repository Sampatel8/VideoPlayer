//
//  Videos.swift
//  VideoPlayer
//
//  Created by Smit Patel on 2022-05-08.
//

import Foundation

struct Videos : Codable{
    
    var id : String
    var title : String
    var hlsURL : String
    var fullURL : String
    var description : String
    var publishedAt : String
    var author : Author
}

struct Author : Codable{
    var id : String
    var name : String
}
