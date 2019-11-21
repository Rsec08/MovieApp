//
//  detailsViewController.swift
//  MovieAppList
//
//  Created by Rahul Sharma on 20/11/19.
//  Copyright © 2019 Rahul. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

struct Moviedetails {
    var moviename:String
    var popularity:Float
    var releasedate:String
    var descr:String
    var duration:Int
    var poster:String

}

class detailsViewController: UIViewController{

   
    @IBOutlet weak var Moviedescrib: UITextView!
    
    @IBOutlet weak var Moviepopularity: UILabel!
    @IBOutlet weak var Movierating: UILabel!
    @IBOutlet weak var Movierelease: UILabel!
    
    @IBOutlet weak var Movietitle: UILabel!
    @IBOutlet weak var Movieimage: UIImageView!
    var name = "sameclass"
    let IMAGE_URL = "https://image.tmdb.org/t/p/w780"
   var Moviedestails = [Moviedetails]()
   
    override func viewDidLoad() {
      self.Movietitle.text = name
        super.viewDidLoad()
        self.getMoviedetailsresult()
    
       

        // Do any additional setup after loading the view.
    }
    
    func getMoviedetailsresult(){
        let imagedetailsUrl = "https://api.themoviedb.org/3/movie/\(name)?api_key=55957fcf3ba81b137f8fc01ac5a31fb5"
        Alamofire.request(imagedetailsUrl, method: .get).responseJSON{
            response in
            if let data  = response.data{
                self.parsemovieData(data:data)
            }
        }
        print(Moviedestails.count)
       
    }
    
    func parsemovieData(data:Data) {
        do{
            let jsonresponse = try JSON(data:data)
            let title = jsonresponse["original_title"].string!
            let popularity = jsonresponse["popularity"].float!
            let releasedatevalue = jsonresponse["release_date"].string!
            let descr = jsonresponse["overview"].string!
            let duration = jsonresponse["runtime"].int!
            let movieposter = jsonresponse["backdrop_path"].string
            Moviedestails.append(.init(moviename: title, popularity: popularity, releasedate: releasedatevalue, descr: descr, duration: duration, poster: movieposter!))
           // self.Moviename.text = Moviedestails[0].moviename
            self.Moviedescrib.text = Moviedestails[0].descr
            self.Moviepopularity.text = String(format: "%.1f", Moviedestails[0].popularity)
            self.Movierating.text = String(Moviedestails[0].duration) + " Min"
            self.Movierelease.text = Moviedestails[0].releasedate
            self.Movietitle.text = Moviedestails[0].moviename
            let imageurl = self.IMAGE_URL + movieposter!
            let urlimge = URL(string: imageurl)
            self.Movieimage.kf.setImage(with: urlimge)
            
            
            
        } catch{
            //exception()
        }
        
        
        
    }
    
    

}
