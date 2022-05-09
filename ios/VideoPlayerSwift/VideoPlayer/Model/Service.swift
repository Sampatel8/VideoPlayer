//
//  Service.swift
//  VideoPlayer
//
//  Created by Smit Patel on 2022-05-08.
//

import Foundation

protocol ServiceDelegate{
    func updateVideos(videos: [Videos])
    func reciveError(error : Error)
}

struct Service{
    
    var delegate : ServiceDelegate?
    
    func fetchVideos(from url : String){
        
        if let safeURL = URL(string: url){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: safeURL) { data, response, error in
                
                if error != nil {
                    self.delegate?.reciveError(error: error!)
                }
                if let safeData = data{
                    
                    do{
                        let jsonData = try JSONDecoder().decode([Videos].self, from: safeData)
                        
                        DispatchQueue.main.async {
                            let sortedData = sortByDate(on: jsonData)
                            self.delegate?.updateVideos(videos: sortedData)
                        }
                        
                    } catch{
                        self.delegate?.reciveError(error: error)
                    }
                    
                }
            }
            task.resume()
        }
        
    }
    
    func sortByDate(on array: [Videos]) -> [Videos]{
        var convertedArray: [Videos] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        convertedArray = array.sorted(by: { dateFormatter.date(from: $0.publishedAt)?.compare(dateFormatter.date(from: $1.publishedAt)!) == .orderedAscending
        })
        return convertedArray
    }
}
