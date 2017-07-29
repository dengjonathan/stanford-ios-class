//
//  ImageViewController.swift
//  Cassini
//
//  Created by Jonathan Deng on 7/29/17.
//  Copyright © 2017 Jonathan Deng. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    // MARK: properties
    var imageUrl: URL? {
        didSet {
            image = nil
            if isViewOnScreen() {
                fetchImage()
            }
        }
    }
    
    fileprivate var imageView = UIImageView()
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            setScrollViewContentSize()
            scrollView.addSubview(imageView)
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
        }
    }

    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            setScrollViewContentSize()
        }
    }
    
    private func fetchImage() {
        if let url = imageUrl {
            let urlContents = try? Data(contentsOf: url)
            if let imageData = urlContents {
                image = UIImage(data: imageData)
            }
        }
    }
    
    private func isViewOnScreen() -> Bool {
        return view.window != nil
    }
    
    private func setScrollViewContentSize() {
        scrollView?.contentSize = imageView.frame.size
    }
    
    //MARK: lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        imageUrl =  URL(string: "http://www.xmcgraw.com/wp-content/uploads/2014/12/storyboard-exit-flow.png")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
