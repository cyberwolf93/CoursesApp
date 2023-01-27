//
//  ListDetailsViewController.swift
//  PhotographySchoolLessonApp
//
//  Created by Ahmed Mohiy on 27/01/2023.
//

import UIKit
import SDWebImage
import AVKit
import AVFoundation

class ListDetailsViewController: UIViewController {
    
    //MARK: - Views
    var scrollView:UIScrollView?
    var parenView: UIView?
    var thumbnailView: UIImageView?
    var labelTitle: UILabel?
    var labelDescription: UILabel?
    var playImageView: UIImageView?
    
    //MARK: - Variables
    var viewModel: ListDetailsViewModel?
    var contentPadding: CGFloat = 10.0
    var labelDescriptionPadding: CGFloat = 5.0
    var lastViewBotomPadding: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        self.view.backgroundColor = .clear
    }
    
    func initUI() {
        createDownloadBarButton()
        createScrollView()
        createParentView()
        createThumbnailView()
        createTitle()
        createDescription()
    }
    
    //MARK: - View Creation
    func createDownloadBarButton() {
        let button = UIButton()
        var confguration = UIButton.Configuration.plain()
        confguration.imagePadding = 5
        confguration.contentInsets = .zero
        button.setImage(UIImage(systemName: "icloud.and.arrow.down"), for: .normal)
        button.setTitle("lesso_details_download".localized(), for: .normal)
        button.configuration = confguration
        let downloadButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItems = [downloadButton]
    }
    
    // create scrollview
    func createScrollView() {
        scrollView = UIScrollView()
        scrollView?.backgroundColor = .clear
        scrollView?.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView!)
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView!.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            scrollView!.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView!.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            scrollView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    // Create Parent View
    func createParentView() {
        guard let scrollView else {return}
        
        parenView = UIView()
        parenView?.backgroundColor = .clear
        scrollView.addSubview(parenView!)
        parenView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            parenView!.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            parenView!.topAnchor.constraint(equalTo: scrollView.topAnchor),
            parenView!.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            parenView!.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            parenView!.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

        ])

       
        
    }
    
    // Create Thumbnail view
    func createThumbnailView() {
        guard let parenView else {return}
        
        thumbnailView = UIImageView()
        thumbnailView!.sd_setImage(with: URL(string: viewModel?.lesson.thumbnailUrl ?? ""))
        thumbnailView!.translatesAutoresizingMaskIntoConstraints = false
        parenView.addSubview(thumbnailView!)
        NSLayoutConstraint.activate([
            thumbnailView!.leftAnchor.constraint(equalTo: parenView.leftAnchor),
            thumbnailView!.topAnchor.constraint(equalTo: parenView.topAnchor),
            thumbnailView!.rightAnchor.constraint(equalTo: parenView.rightAnchor),
            thumbnailView!.heightAnchor.constraint(equalToConstant: view.frame.width * 9 / 16)
        ])
        
        // gradient view
        let gradientView = UIView(frame: view.bounds)
        gradientView.backgroundColor = .black.withAlphaComponent(0.4)
        thumbnailView?.addSubview(gradientView)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gradientView.leftAnchor.constraint(equalTo: thumbnailView!.leftAnchor),
            gradientView.topAnchor.constraint(equalTo: thumbnailView!.topAnchor),
            gradientView.rightAnchor.constraint(equalTo: thumbnailView!.rightAnchor),
            gradientView.bottomAnchor.constraint(equalTo: thumbnailView!.bottomAnchor)
        ])
    
        // Create play button
        playImageView = UIImageView(image: UIImage(systemName: "play.fill"))
        playImageView!.tintColor = .white
        thumbnailView!.addSubview(playImageView!)
        playImageView!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playImageView!.centerXAnchor.constraint(equalTo: thumbnailView!.centerXAnchor),
            playImageView!.centerYAnchor.constraint(equalTo: thumbnailView!.centerYAnchor),
            playImageView!.widthAnchor.constraint(equalToConstant: 50),
            playImageView!.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        // Add tap gesture to playImageView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonPlayClicked(gesture:)))
        playImageView!.isUserInteractionEnabled = true
        thumbnailView!.isUserInteractionEnabled = true
        playImageView!.addGestureRecognizer(tapGesture)
    }
    
    
    // Create title
    func createTitle() {
        guard let thumbnailView else {return}
        guard let parenView else {return}
        
        // title label
        labelTitle = UILabel()
        labelTitle!.text = viewModel?.lesson.name
        labelTitle!.font = UIFont.preferredFont(forTextStyle: .title1)
        labelTitle!.adjustsFontForContentSizeCategory = true
        labelTitle!.textColor = .label
        labelTitle!.numberOfLines = 0
        
        parenView.addSubview(labelTitle!)
        labelTitle!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelTitle!.leftAnchor.constraint(equalTo: parenView.leftAnchor, constant: contentPadding),
            labelTitle!.topAnchor.constraint(equalTo: thumbnailView.bottomAnchor, constant: contentPadding),
            labelTitle!.rightAnchor.constraint(equalTo: parenView.rightAnchor, constant: -contentPadding)
        ])
    }
    
    // Create description
    func createDescription() {
        guard let labelTitle else {return}
        guard let parenView else {return}
        
        // title label
        labelDescription = UILabel()
        labelDescription!.text = (viewModel?.lesson.lessonDescription ?? "") + (viewModel?.lesson.lessonDescription ?? "")
        labelDescription!.font = UIFont.preferredFont(forTextStyle: .caption1)
        labelDescription!.adjustsFontForContentSizeCategory = true
        labelDescription!.textColor = .label
        labelDescription!.numberOfLines = 0
        
        parenView.addSubview(labelDescription!)
        labelDescription!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelDescription!.leftAnchor.constraint(equalTo: parenView.leftAnchor, constant: contentPadding),
            labelDescription!.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: contentPadding),
            labelDescription!.rightAnchor.constraint(equalTo: parenView.rightAnchor, constant: -contentPadding),
            labelDescription!.bottomAnchor.constraint(equalTo: parenView.bottomAnchor, constant: -lastViewBotomPadding)
        ])
    }
    
    //MARK: - ACTIONS
    @objc func buttonPlayClicked(gesture: UITapGestureRecognizer) {
        guard let lesson = viewModel?.lesson else {
            return
        }
        let playerViewModel = PlayerViewControllerViewModel(lesson: lesson)
        let viewController = PlayerViewController()
        viewController.viewModel  = playerViewModel
        present(viewController, animated: true)
    }
    
}
