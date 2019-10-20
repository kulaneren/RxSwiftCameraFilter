//
//  ViewController.swift
//  RxSCameraFilter
//
//  Created by eren kulan on 17/10/2019.
//  Copyright © 2019 eren kulan. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var btnApplyFilter: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navC = segue.destination as? UINavigationController{
            if let vcPhotosCollection = navC.viewControllers.first as? PhotosCollectionViewController {
                vcPhotosCollection.selectedPhoto.subscribe(onNext: { [weak self] photo in
                    DispatchQueue.main.async {
                        self?.photoImageView.image = photo
                        self?.btnApplyFilter.isHidden = false
                    }
                }).disposed(by: disposeBag)
            }
        }
    }
    
    @IBAction func btnApplyFilterTapped(_ sender: UIButton) {
        guard let sourceImage = self.photoImageView.image else {
            return
        }
        
        FilterService().applyFilter(to: sourceImage)
            .subscribe(onNext: {image in
                DispatchQueue.main.async {
                    self.photoImageView.image = image
                }
            }).disposed(by: disposeBag)
        
//        FilterService().applyFilter(to: sourceImage) { filteredImage in
//
//            DispatchQueue.main.async {
//                self.photoImageView.image = filteredImage
//            }
//        }
    }
}

