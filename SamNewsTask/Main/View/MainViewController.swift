//
//  MainViewController.swift
//  SamNewsTask
//
//  Created by tzahi moyal on 31/01/2020.
//  Copyright © 2020 TZAHIMOYAL. All rights reserved.
//

import UIKit
import EZProgressHUD
import RxSwift
import Alamofire
import AlamofireImage

class MainViewController: UIViewController {

  @IBOutlet weak var articlesTableView: UITableView!
  @IBOutlet weak var sourcesCollectionView: UICollectionView!
  
  var hud:EZProgress? = nil
  
  var mainViewModel = MainViewModel()
  let disposeBag = DisposeBag()
  
  var sourcesList:[SourcesResponse.SourceItem] = []
  var articelsList:[TopHeadlinesResponse.ArticleItem] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    sourcesCollectionView.delegate = self
    sourcesCollectionView.dataSource = self
    
    articlesTableView.delegate = self
    articlesTableView.dataSource = self

    
    setupBindings()
    initViews()
    hud?.show()
    mainViewModel.getAllSources()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    
    
  }
  
  // MARK: - Init Views
  
  func initViews() {
    let options = EZProgressOptions()

    options.radius = 120
    options.firstLayerStrokeColor = SOURCE_NON_SELECETED_COLOR
    options.secondLayerStrokeColor = SOURCE_SELECETED_COLOR
    options.thirdLayerStrokeColor = .darkGray
    options.strokeWidth = 12
    options.titleTextColor = .white
    options.transViewBackgroundColor = .white
    options.animationOption = EZAnimationOptions.xyRotation
    hud = EZProgressHUD.setProgress(with: options)
  }
  
  
  // MARK: - Bindings
  
  private func setupBindings() {
              
      // binding sources
      
      mainViewModel
      .sourcesList
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { (sourcesList) in
        self.sourcesList = sourcesList
        self.sourcesCollectionView.reloadData()
      })
      .disposed(by: disposeBag)
      
      // binding articels
      
      mainViewModel
      .articelsList
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { (articelsList) in
        self.articelsList = articelsList
        self.articlesTableView.reloadData()
        self.hud?.dismiss(completion: nil)
      })
      .disposed(by: disposeBag)
    
    // binding connection error
    
    mainViewModel
    .isConnectionError
    .observeOn(MainScheduler.instance)
    .subscribe(onNext: { (isConnectionError) in
      if isConnectionError {self.showConnectionAlertView()}
    })
    .disposed(by: disposeBag)
  }

  //MARK: - UI Alerts
  
  func showConnectionAlertView() {
    self.hud?.dismiss(completion: nil)
      let alert = UIAlertController(title: "Connection issue", message: "Please check your connection to network", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alert.addAction(okAction)

      present(alert, animated: true, completion: nil)
  }
  
}


// MARK: - CollectionView Datasource and Delegate

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return sourcesList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let source = sourcesList[indexPath.row]
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCell
    cell.title.text = source.name
    
    cell.contentView.layer.cornerRadius = 5.0
    
    if source.isSelected {
      cell.contentView.backgroundColor = .brown
    } else {
      cell.contentView.backgroundColor = SOURCE_NON_SELECETED_COLOR
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let source = sourcesList[indexPath.row]
    if source.isSelected {return}
    sourcesList[mainViewModel.lastSourceSelectedIndex].isSelected = false
    let changedSourceSelectedIndex = mainViewModel.lastSourceSelectedIndex
    mainViewModel.lastSourceSelectedIndex = indexPath.row
    sourcesList[indexPath.row].isSelected = !source.isSelected
    mainViewModel.getArticlesForSource(source: source.id)
    hud?.show()
    
    mainViewModel.saveLastSourceSelected(indexPath.row)
    collectionView.reloadItems(at: [indexPath, IndexPath(row: changedSourceSelectedIndex, section: 0)])
  }

}

// MARK: - TableView Datasource and Delegate

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return articelsList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let article = articelsList[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "ArticelCell", for: indexPath) as! ArticelCell
    cell.titleLabel?.text = article.title
    if let imageURLString = article.urlToImage,
      let imageURL = URL(string: imageURLString) {
      let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
          size: cell.frame.size,
          radius: 20.0
      )

      cell.articelImage.layer.cornerRadius = 20.0
      cell.articelImage.af_setImage(
          withURL: imageURL,
          placeholderImage: UIImage(color: .gray, size: cell.frame.size),
          filter: filter,
          imageTransition: .crossDissolve(0.2)
      )

    }
      
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return ARTICEL_TABLE_CELL_HEIGHT
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let article = articelsList[indexPath.row]
    if let urlString = article.url,
      let url = URL(string: urlString){
        UIApplication.shared.open(url)
    }
  }
}


