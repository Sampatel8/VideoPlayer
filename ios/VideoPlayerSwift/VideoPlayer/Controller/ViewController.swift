//
//  ViewController.swift
//  VideoPlayer
//
//  Created by Smit Patel on 2022-05-08.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var videos : [Videos] = []
    var service = Service() // Object of Service struct
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service.delegate = self
        service.fetchVideos(from: "http://localhost:4000/videos")
    }
    
    @IBAction func perviousButtonTapped(_ sender: Any){
        
    }
    @IBAction func playButtonTapped(_ sender: Any) {
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
    }
    
    // MARK: Display Video from url
    func displayVideo(with url: String, view : UIView){
        
        guard let safeurl = URL(string: url) else {return}
        player = AVPlayer(url: safeurl)
       playerLayer = AVPlayerLayer(player: player)

       playerLayer.videoGravity = .resizeAspectFill
       playerLayer.needsDisplayOnBoundsChange = true
       playerLayer.frame = view.bounds

        view.layer.masksToBounds = true
        view.layer.addSublayer(playerLayer)
        player.play()
    }
}

extension ViewController : ServiceDelegate{
    
    func updateVideos(videos: [Videos]) {
        self.videos.removeAll()
        
        self.videos.append(contentsOf: videos)
        //self.videos = service.sortByDate(on: videos)
        displayVideo(with: self.videos[1].fullURL, view: videoView)
    }
    
    func reciveError(error: Error) {
        print(error.localizedDescription)
    }
    
    
}

