//
//  RecordingViewController.swift
//  DynamicBrushes
//
//  Created by Jingyi Li on 2/5/18.
//  Copyright © 2018 pixelmaid. All rights reserved.
//

import Foundation
import UIKit

class GestureRecording {
    var id:String;
    var resultantStrokes = [String:[String]]();
    init(id:String, resultantStrokes:[String:[String]]) {
        self.id = id;
        self.resultantStrokes = resultantStrokes;
    }
}

extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
    }
}

class RecordingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    //data source
    var gestures = [GestureRecording]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        let recordingKey = NSUUID().uuidString

        _ = StylusManager.recordEvent.addHandler(target:self, handler: RecordingViewController.recordingCreatedHandler, key: recordingKey)
        collectionView?.register(RecordingFrameCell.self, forCellWithReuseIdentifier: "cell")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gestures.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordingFrameCell", for: indexPath) as! RecordingFrameCell
//        cell.recordingThumbnail.image =
        print ("recording now has ", collectionView.numberOfItems(inSection:0))

        cell.backgroundColor = UIColor.random
        return cell
    }
    
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 400, height: 200)
//    }
    
    func recordingCreatedHandler (data:(String, StylusRecordingPackage), key:String) {
        //get data here
        print ("****** RECORDING NEW DATA!")
        let stylusdata = data.1
        gestures.append(GestureRecording(id: stylusdata.id, resultantStrokes: stylusdata.resultantStrokes))
//        let IndexPath = NSIndexPath(item: self.gestures.count-1, section:0)
//        print (IndexPath)
//        collectionView.insertItems(at: [IndexPath as IndexPath])
        
        collectionView?.reloadData()
        //print ("recording tried inserting now len ", collectionView?.numberOfItems(inSection:0))

        //        self.collectionView?.reloadData()
    }

}

