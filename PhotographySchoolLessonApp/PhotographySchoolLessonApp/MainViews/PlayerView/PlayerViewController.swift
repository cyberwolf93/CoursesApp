//
//  PlayerViewController.swift
//  PhotographySchoolLessonApp
//
//  Created by Ahmed Mohiy on 27/01/2023.
//

import UIKit
import AVKit
import AVFoundation

class PlayerViewController: AVPlayerViewController{
    
    var viewModel: PlayerViewControllerViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player = viewModel?.getAvPlayer()
        player?.play()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscapeLeft, .portrait, .landscapeRight]
    }
    

}
