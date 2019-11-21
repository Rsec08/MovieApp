//
//  ViewController.swift
//  MovieAppList
//
//  Created by Rahul Sharma on 20/11/19.
//  Copyright © 2019 Rahul. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

struct Movie{
    var title:String
    var vote:Float
    var url:String
    var desc:String
    var releasedate:String
    var movieID: Int
}

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    

    @IBOutlet weak var MoviesCollection: UICollectionView!
    
    let MovieUrl = "https://api.themoviedb.org/3/movie/now_playing?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&language=en-US"
    let IMAGE_URL = "https://image.tmdb.org/t/p/w780/"
    
    var Movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getMovieresult()
        MoviesCollection.dataSource = self
        MoviesCollection.delegate = self
        let layout = self.MoviesCollection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0,left: 5,bottom: 0,right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.MoviesCollection.frame.size.width - 20)/2,
                                 height: self.MoviesCollection.frame.size.height/3)
        // Do any additional setup after loading the view.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MovieCollectionVIew
    let Movie = Movies[indexPath.row]
    let movieImageUrl = Movie.url
    let url = URL(string: movieImageUrl)
        Cell.movieImage.kf.setImage(with: url)
        Cell.movierating.text = String(format: "%.1f", Movie.vote)
        Cell.layer.borderColor = UIColor.lightGray.cgColor
        Cell.layer.borderWidth = 5
       
     return Cell
    }
    
    func getMovieresult(){
        Alamofire.request(MovieUrl, method: .get).responseJSON{
            response in
            if let data  = response.data{
                self.parsemovieData(data:data)
                self.MoviesCollection.reloadData()
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let selectCell = collectionView.cellForItem(at: indexPath)
        selectCell?.layer.borderColor = UIColor.lightGray.cgColor
        selectCell?.layer.borderWidth = 5
        let movietitle = Movies[indexPath.row].movieID
         print(movietitle)
        let detailsViewController  = storyboard?.instantiateViewController(withIdentifier: "detailsViewController") as! detailsViewController
        if String(movietitle) != nil {
            detailsViewController.name = String(movietitle)
            self.navigationController?.pushViewController(detailsViewController, animated: true)
        }else{
            print("Error msg")
        }
        
        
        
        
       
    
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let deselectCell = collectionView.cellForItem(at: indexPath)
        deselectCell?.layer.borderColor = UIColor.lightGray.cgColor
        deselectCell?.layer.borderWidth = 8
    }
    func parsemovieData(data:Data) {
        do{
            let jsonresponse = try JSON(data:data)
            let results = jsonresponse["results"].arrayValue
            for result in results {
                let title = result["title"].string!
                let vote = result["vote_average"].float!
                let MOVIEIMAGEURL = "\(IMAGE_URL)\(String(describing: result["poster_path"].string!))"
                let descib = result["overview"].string!
                let releasedate = result["release_date"].string!
                let movieid = result["id"].int!
                Movies.append(Movie.init(title: title, vote: vote, url: MOVIEIMAGEURL, desc: descib, releasedate: releasedate, movieID:movieid))
            }
        } catch{
            //exception()
        }
        
        
        
    }
    
    
}

