//
//  ViewController.swift
//  SwiftInfiniteScroll
//
//  Created by Yan Wye Huong on 31/8/14.
//  Copyright (c) 2014 Sprubix. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    let numPages: Int = 3
    var mainScrollView: UIScrollView?
    var documentTitle = [String]()
    
    var prevIndex: Int = 0, currIndex: Int = 0, nextIndex: Int = 0
    var pages = [UILabel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // create our array of documents
        for (var i = 0; i < 10; i++) {
            documentTitle.insert(String(format: "Page %i", i), atIndex: i)
        }
        
        initSubviews()
        
        view.addSubview(mainScrollView!);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initSubviews() {
        var fm: CGRect = UIScreen.mainScreen().bounds
        
        self.mainScrollView = UIScrollView(frame:CGRectMake(0, 0, fm.size.width, fm.size.height))
        self.mainScrollView!.contentSize = CGSizeMake(self.mainScrollView!.frame.size.width, self.mainScrollView!.frame.size.height * CGFloat(numPages))
        self.mainScrollView!.backgroundColor = UIColor.greenColor()
        self.mainScrollView!.pagingEnabled = true
        self.mainScrollView!.bounces = false
        self.mainScrollView!.showsHorizontalScrollIndicator = false;
        self.mainScrollView!.scrollRectToVisible(CGRectMake(0, mainScrollView!.frame.size.height, mainScrollView!.frame.size.width, mainScrollView!.frame.size.height), animated: false)

        self.mainScrollView!.delegate = self
        
        for i in 0...numPages {
            var tempLabel = UILabel(frame:  CGRectMake(0, self.mainScrollView!.frame.size.height * CGFloat(i), fm.size.width, fm.size.height))
            tempLabel.textAlignment = NSTextAlignment.Center

            pages.insert(tempLabel, atIndex: i)
            self.mainScrollView!.addSubview(pages[i]);
        }
        
        loadPageWithId(9, onPage: 0)
        loadPageWithId(0, onPage: 1) // starting page
        loadPageWithId(1, onPage: 2)
    }
    
    func loadPageWithId(index: Int, onPage page: Int) {
        switch(page) {
        case 0:
            pages[0].text = documentTitle[index]
            break
        case 1:
            pages[1].text = documentTitle[index]
            break
        case 2:
            pages[2].text = documentTitle[index]
            break
        default:
            break
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        //println("scrolling...")
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView!) {
        // moving forward
        if(scrollView.contentOffset.y > mainScrollView!.frame.size.height) {
            // load current doc data on first page
            loadPageWithId(currIndex, onPage: 0)
            
            // add one to current index or reset to 0 if reached end
            currIndex = (currIndex >= documentTitle.count - 1) ? 0 : currIndex + 1
            loadPageWithId(currIndex, onPage: 1)
            
            // last page contains either next time in array or first if we reached the end
            nextIndex = (currIndex >= documentTitle.count - 1) ? 0 : currIndex + 1
            loadPageWithId(nextIndex, onPage: 2)
        }
        
        // moving backward
        if(scrollView.contentOffset.y < mainScrollView!.frame.size.height) {
            // load current doc data on last page
            loadPageWithId(currIndex, onPage: 2)
            
            // subtract one from current index or go to the end if we have reached the beginning
            currIndex = (currIndex == 0) ? documentTitle.count - 1 : currIndex - 1
            loadPageWithId(currIndex, onPage: 1)
            
            // first page contains either the prev item in array or the last item if we have reached the beginning
            prevIndex = (currIndex == 0) ? documentTitle.count - 1 : currIndex - 1
            loadPageWithId(prevIndex, onPage: 0)
        }
        
        // reset offset to the middle page
        self.mainScrollView!.scrollRectToVisible(CGRectMake(0, mainScrollView!.frame.size.height, mainScrollView!.frame.size.width, mainScrollView!.frame.size.height), animated: false)
    }
    
}

