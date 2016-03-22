//
//  ViewController.swift
//  TheCircleVoice
//
//  Created by James Hovet on 3/21/16.
//  Copyright © 2016 James Hovet. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, XMLParserDelegate {

    
    //assign the xml parser object to a local variable
    var xmlParser : RssFetcher!

    
    //assign rows in section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xmlParser.arrParsedData.count
    }
    //assign number of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //put data into the cells
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCellWithIdentifier("Article") as! ArticleTableViewCell
        
        let currentDict = xmlParser.arrParsedData[indexPath.row] as Dictionary<String,String>
        
        cell.ArticleData = currentDict

        cell.ArticleTitle.text = currentDict["title"]
        cell.Byline.text = (currentDict["dc:creator"]! as NSString).substringFromIndex(3)
        let index = currentDict["description"]?.endIndex.advancedBy(-10)
        cell.ArticlePreview.text = currentDict["description"]!.substringToIndex(index!)
        
        
        return cell
        
    }
    
    
    //worry about getting the data from the parser
    func parsingWasFinished() {
        self.TableView.reloadData()
    }
    
    @IBOutlet weak var TableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("did load")
        xmlParser = RssFetcher()
        xmlParser.delegate = self
        for (var i = 1;i<5;i++){
            //URL of the CV rss feed
            let URL = NSURL(string: "http://thecirclevoice.org/feed/?paged="+i.description)
            xmlParser.startParsingWithContentsOfURL(URL!)
        }
    }
    
    //prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EnterArticleFromTable" {
            let secondViewController = segue.destinationViewController as! ArticleViewController
            secondViewController.message = sender?.ArticleData
        } else {
            let secondViewController = segue.destinationViewController as! ArticleViewController
            secondViewController.message = xmlParser.arrParsedData[0]
        }
    }
    
    //return from segue
    
    @IBAction func returnFromSegueActions(sender : UIStoryboardSegue){
        
    }

    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        if let id = identifier{
            if id == "idFirstSegueUnwind" {
                let unwindSegue = ArticleEnterUnwind(identifier: id, source: fromViewController, destination: toViewController, performHandler: { () -> Void in
                    
                })
                return unwindSegue
            }
        }
        
        return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)!
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

