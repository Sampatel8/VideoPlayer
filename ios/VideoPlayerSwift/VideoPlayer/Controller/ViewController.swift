//
//  ViewController.swift
//  VideoPlayer
//
//  Created by Smit Patel on 2022-05-08.
//

import UIKit
import AVKit
import MarkdownKit

class ViewController: UIViewController {
    
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var videoActivityIndicator: UIActivityIndicatorView!
    
    var videos : [Videos] = []
    var service = Service()
    var player = AVPlayer()
    let markdownParser = MarkdownParser()
    var playerLayer = AVPlayerLayer()
    
    var videoIndex = 0  // For Tracking current Index of Video
    var isButtonsHide = false    // for setting up buttons hide status
    var isVideoPlayable = true  //  to check weather video is playable or not
    var isVideoPlay = false     // for setting up play and pause buttons
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service.delegate = self
        service.fetchVideos(from: "http://localhost:4000/videos")
    }
    
    @IBAction func videoPlayerTapped(_ sender: UITapGestureRecognizer) {
        isButtonsHide.toggle()
        hideButtons(hideNext: isButtonsHide, hidePrevious: isButtonsHide, hidePlay: isButtonsHide)
    }
    
    
    @IBAction func perviousButtonTapped(_ sender: Any){
        nextButton.isEnabled = true
        nextButton.backgroundColor = .white
        videoIndex -= 1
        errorLabel.isHidden = true
        player.replaceCurrentItem(with: nil)
        displayVideo(of: videoIndex, view: videoView)
        titleLabel.text = videos[videoIndex].title
        authorLabel.text = videos[videoIndex].author.name
        detailsLabel.attributedText = markdownParser.parse(videos[videoIndex].description)
        if videoIndex == 0{
            previousButton.isEnabled = false
        }
        previousButton.isEnabled = videoIndex == 0 ? false : true
        previousButton.backgroundColor = videoIndex == 0 ? .gray : .white
        
    }
    @IBAction func playButtonTapped(_ sender: Any) {
        if isVideoPlayable{
            if isVideoPlay{
                player.pause()
                playButton.setImage(UIImage(named: "play"), for: .normal)
                isVideoPlay = false
            }else {
                player.play()
                isButtonsHide.toggle()
                hideButtons(hideNext: true, hidePrevious: true, hidePlay: true)
                playButton.setImage(UIImage(named: "pause"), for: .normal)
                isVideoPlay = true
            }
        }else{
            print("Video Is Not Playable...")
        }
        
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        previousButton.isEnabled = true
        previousButton.backgroundColor = .white
        videoIndex += 1
        errorLabel.isHidden = true
        player.replaceCurrentItem(with: nil)
        displayVideo(of: videoIndex, view: videoView)
        titleLabel.text = videos[videoIndex].title
        authorLabel.text = videos[videoIndex].author.name
        detailsLabel.attributedText = markdownParser.parse(videos[videoIndex].description)
        nextButton.isEnabled = videoIndex == videos.count-1 ? false : true
        nextButton.backgroundColor = videoIndex == videos.count-1 ? .gray : .white
    }
    
}

extension ViewController : ServiceDelegate{
    
    func updateVideos(videos: [Videos]) {
        self.videos.removeAll()
        self.videos.append(contentsOf: videos)
        displayVideo(of: videoIndex, view: videoView)
    }
    
    func reciveError(error: Error) {
        print(error.localizedDescription)
    }
    
    // MARK: Display Video from url
    
    func displayVideo(of index: Int, view : UIView){
        playButton.setImage(UIImage(named: "play"), for: .normal)
        hideButtons(hideNext: true, hidePrevious: true, hidePlay: true)
        videoActivityIndicator.startAnimating()
        videoActivityIndicator.isHidden = false
        
        DispatchQueue.main.async { [self] in
            let url = videos[index].fullURL
            guard let safeurl = URL(string: url) else {return}
            
            
            if !AVAsset(url: safeurl).isPlayable{
                errorLabel.isHidden = false
                isVideoPlayable = false
                isButtonsHide.toggle()
                hideButtons(hideNext: true, hidePrevious: true, hidePlay: true)
                print("Video Is Not Playable/...")
            }else{
                
                isVideoPlayable = true
                player = AVPlayer(url: safeurl)
                playerLayer = AVPlayerLayer(player: player)
                playerLayer.videoGravity = .resizeAspectFill
                playerLayer.needsDisplayOnBoundsChange = true
                playerLayer.frame = view.bounds
                
                view.layer.masksToBounds = true
                view.layer.addSublayer(playerLayer)
                addButtons(on: view)
                hideButtons(hideNext: false, hidePrevious: false, hidePlay: false)
            }
            titleLabel.text = videos[index].title
            authorLabel.text = videos[index].author.name
            detailsLabel.attributedText = markdownParser.parse(videos[videoIndex].description)
            
            videoActivityIndicator.isHidden = true
            videoActivityIndicator.stopAnimating()
            
        }
    }
    
    // MARK: Adding buttons to Player Layer
    func addButtons(on playerView: UIView){
        playerView.addSubview(playButton)
        playerView.addSubview(nextButton)
        playerView.addSubview(previousButton)
        
    }
    
    //MARK: to set buttons hide status
    func hideButtons(hideNext : Bool, hidePrevious : Bool, hidePlay : Bool){
        
        playButton.isHidden = hidePlay
        nextButton.isHidden = hideNext
        previousButton.isHidden = hidePrevious
        
    }
    
}

