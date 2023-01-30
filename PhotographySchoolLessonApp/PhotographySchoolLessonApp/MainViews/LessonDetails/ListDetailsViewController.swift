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
import Combine
import SwiftUI

class ListDetailsViewController: UIViewController {
    
    //MARK: - Views
    var scrollView:UIScrollView?
    var parenView: UIView?
    var thumbnailView: UIImageView?
    var labelTitle: UILabel?
    var labelDescription: UILabel?
    var playImageView: UIImageView?
    var viewSeperator: UIView?
    var labelDownloading: UILabel?
    var progressView: UIProgressView?
    var nextLessonButton: UIButton?
    
    //MARK: - Variables
    var viewModel: ListDetailsViewModel?
    var contentPadding: CGFloat = 10.0
    var labelDescriptionPadding: CGFloat = 5.0
    var lastViewBotomPadding: CGFloat = 50
    private var cancelable = Set<AnyCancellable>()
    
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
        createDownloadProgressView()
        createNextLessonButton()
    }
    
    //MARK: - View Creation
    func createDownloadBarButton() {
        guard let viewModel else {return}
        if viewModel.checkLessonInDownloadQueue() {
            createRemoveDownloanBarButton()
        } else {
            createStartDownloanBarButton()
        }
    }
    
    func createStartDownloanBarButton() {
        let button = UIButton()
        var confguration = UIButton.Configuration.plain()
        confguration.imagePadding = 5
        confguration.contentInsets = .zero
        button.setImage(UIImage(systemName: "icloud.and.arrow.down"), for: .normal)
        button.setTitle("lesson_details_download".localized(), for: .normal)
        button.configuration = confguration
        button.accessibilityIdentifier = DetailsAccessibilityIDType.downlaodButton.rawValue
        button.addTarget(self, action: #selector(startDownloadButtonClicked), for: .touchUpInside)
        let downloadButton = UIBarButtonItem(customView: button)
        downloadButton.customView?.isUserInteractionEnabled = true
        self.navigationItem.rightBarButtonItems = [downloadButton]
    }
    
    func createRemoveDownloanBarButton() {
        let button = UIButton()
        var confguration = UIButton.Configuration.plain()
        confguration.imagePadding = 5
        confguration.contentInsets = .zero
        button.setImage(UIImage(systemName: "trash.slash"), for: .normal)
        button.setTitle("lesson_details_remove".localized(), for: .normal)
        button.configuration = confguration
        button.accessibilityIdentifier = DetailsAccessibilityIDType.downlaodButton.rawValue
        button.addTarget(self, action: #selector(removeDownloadButtonClicked), for: .touchUpInside)
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
        playImageView?.accessibilityTraits = .button
        playImageView?.accessibilityIdentifier = DetailsAccessibilityIDType.playButton.rawValue
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
        labelTitle?.accessibilityIdentifier = DetailsAccessibilityIDType.title.rawValue
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
        labelDescription!.text = viewModel?.lesson.lessonDescription
        labelDescription!.font = UIFont.preferredFont(forTextStyle: .caption1)
        labelDescription!.adjustsFontForContentSizeCategory = true
        labelDescription!.textColor = .label
        labelDescription!.numberOfLines = 0
        
        parenView.addSubview(labelDescription!)
        labelDescription?.accessibilityIdentifier = DetailsAccessibilityIDType.description.rawValue
        labelDescription!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelDescription!.leftAnchor.constraint(equalTo: parenView.leftAnchor, constant: contentPadding),
            labelDescription!.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: contentPadding),
            labelDescription!.rightAnchor.constraint(equalTo: parenView.rightAnchor, constant: -contentPadding),
        ])
    }
    
    // create download progress view
    func createDownloadProgressView() {
        guard let labelDescription else {return}
        guard let parenView else {return}
        
        // Seperator view
        viewSeperator = UIView()
        viewSeperator!.backgroundColor = .gray.withAlphaComponent(0.4)
        parenView.addSubview(viewSeperator!)
        viewSeperator?.accessibilityIdentifier = DetailsAccessibilityIDType.downloadViewSeparator.rawValue
        viewSeperator!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewSeperator!.topAnchor.constraint(equalTo: labelDescription.bottomAnchor, constant: contentPadding),
            viewSeperator!.leftAnchor.constraint(equalTo: parenView.leftAnchor, constant: contentPadding),
            viewSeperator!.rightAnchor.constraint(equalTo: parenView.rightAnchor, constant: -contentPadding),
            viewSeperator!.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        // Label Downloading
        labelDownloading = UILabel()
        labelDownloading?.text = "lesson_details_downloading".localized()
        labelDownloading?.font = UIFont.preferredFont(forTextStyle: .title2)
        labelDownloading?.adjustsFontForContentSizeCategory = true
        labelDownloading?.textColor = .systemBlue
        labelDownloading?.numberOfLines = 1
        parenView.addSubview(labelDownloading!)
        labelDownloading?.accessibilityIdentifier = DetailsAccessibilityIDType.downloadLabel.rawValue
        labelDownloading?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelDownloading!.topAnchor.constraint(equalTo: viewSeperator!.bottomAnchor, constant: contentPadding),
            labelDownloading!.leftAnchor.constraint(equalTo: parenView.leftAnchor, constant: contentPadding),
        ])
        
        // download progress bar
        progressView = UIProgressView()
        progressView?.trackTintColor = .darkGray
        progressView?.progressTintColor = .systemBlue
        progressView?.progressViewStyle = .bar
        progressView?.progress = 0.01
        progressView?.isUserInteractionEnabled = false
        progressView?.translatesAutoresizingMaskIntoConstraints = false
        parenView.addSubview(progressView!)
        progressView?.accessibilityIdentifier = DetailsAccessibilityIDType.downloadProgressView.rawValue
        NSLayoutConstraint.activate([
            progressView!.topAnchor.constraint(equalTo: labelDownloading!.bottomAnchor, constant: 2),
            progressView!.leftAnchor.constraint(equalTo: parenView.leftAnchor, constant: contentPadding),
            progressView!.rightAnchor.constraint(equalTo: parenView.rightAnchor, constant: -contentPadding),
            progressView!.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        handelDownloadingViewResponsiveness()
    }
    
    func createNextLessonButton() {
        guard let parenView else {return}
        guard let progressView else {return}
        
        nextLessonButton = UIButton()
        nextLessonButton?.tintColor = .systemBlue
        nextLessonButton?.setTitle("lesson_details_next_lesson".localized(), for: .normal)
        nextLessonButton?.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 5
        configuration.imagePlacement = .trailing
        nextLessonButton?.configuration = configuration
        parenView.addSubview(nextLessonButton!)
        nextLessonButton?.addTarget(self, action: #selector(buttonNextLessonClicked), for: .touchUpInside)
        nextLessonButton?.accessibilityIdentifier = DetailsAccessibilityIDType.nextLessonButton.rawValue
        nextLessonButton?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextLessonButton!.rightAnchor.constraint(equalTo: parenView.rightAnchor),
            nextLessonButton!.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 50),
            nextLessonButton!.bottomAnchor.constraint(equalTo: parenView.bottomAnchor, constant: -lastViewBotomPadding)
        ])
        
        // Hide next button if there is no next lesson
        nextLessonButton?.isHidden = (viewModel?.nextLessons.count ?? 0) == 0
    }
    
    //MARK: - Helping methods for download view
    
    func shouldHideDownloadView(hide: Bool) {
        viewSeperator?.isHidden = hide
        labelDownloading?.isHidden = hide
        progressView?.isHidden = hide
    }
    
    func handelDownloadingViewResponsiveness() {
        var shouldHideView = true
        if let viewModel, viewModel.checkLessonInDownloadQueue(), !viewModel.checkLessonDownloadComplete() {
            shouldHideView = false
        }
        shouldHideDownloadView(hide: shouldHideView)
        
        // listen on download complete
        viewModel?.downloadCompleteSubject
            .sink(receiveValue: { [weak self]_ in
                self?.shouldHideDownloadView(hide: true)
            }).store(in: &cancelable)
        
        // listen on download progress
        viewModel?.downloadProgressSubject
            .sink(receiveValue: { [weak self] progress in
                if self?.progressView?.isHidden ?? false {
                    self?.shouldHideDownloadView(hide: false)
                }
                UIView.animate(withDuration: 0.4, delay: 0) {
                    self?.progressView?.progress = progress
                }
                
            }).store(in: &cancelable)
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
    
    @objc func buttonNextLessonClicked() {
        guard let nextLesson = viewModel?.getNextLesson(),
              let nextLessonList = viewModel?.prepareNextLessonList() else {
            return
        }
        
        let viewController = UIHostingController(rootView:
                                                ListDetailsRepresentableView(lesson: nextLesson, nextLessons:nextLessonList)
                                                        .navigationBarTitleDisplayMode(.inline))
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func startDownloadButtonClicked() {
        self.viewModel?.startDownload()
        self.createRemoveDownloanBarButton()
        self.shouldHideDownloadView(hide: false)
    }
    
    @objc func removeDownloadButtonClicked() {
        self.viewModel?.removeDownload()
        self.createStartDownloanBarButton()
        self.shouldHideDownloadView(hide: true)
    }
    
}
