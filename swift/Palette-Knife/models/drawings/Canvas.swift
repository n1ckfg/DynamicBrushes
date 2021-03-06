//
//  Canvas.swift
//  PaletteKnife
//
//  Created by JENNIFER MARY JACOBS on 6/24/16.
//  Copyright © 2016 pixelmaid. All rights reserved.
//

import Foundation
import UIKit
//Canvas
//stores multiple drawings

class Canvas: WebTransmitter, Hashable{
    var id = NSUUID().uuidString;
    var name:String;
    var drawings = [Drawing]()
    var currentDrawing:Drawing?
    var transmitEvent = Event<(String)>()
    var initEvent = Event<(WebTransmitter,String)>()
    var dirty = false;
    var geometryModified = Event<(Geometry,String,String)>()
    
    let drawKey = NSUUID().uuidString;
    let  dataKey = NSUUID().uuidString;
    
    
    //MARK: - Hashable
    var hashValue : Int {
        get {
            return "\(self.id)".hashValue
        }
    }
    
    
    required init(){
        name = "default_"+id;
    }
    
    
    func drawSegment(context:ModifiedCanvasView){
        if(currentDrawing!.dirty){
            currentDrawing?.drawSegment(context: context)
        }
        self.dirty = false;
    }
    
    func initDrawing(){
        currentDrawing = Drawing();
        drawings.append(currentDrawing!)
        _ = currentDrawing!.transmitEvent.addHandler(target: self,handler: Canvas.drawingDataGenerated, key:drawKey);
        _ = currentDrawing!.geometryModified.addHandler(target: self,handler: Canvas.drawHandler, key:dataKey);
        
        var string = "{\"canvas_id\":\""+self.id+"\","
        string += "\"drawing_id\":\""+currentDrawing!.id+"\","
        string += "\"type\":\"new_drawing\"}"
        self.transmitEvent.raise(data:(string));
        
    }
    
    func addSegmentToStroke(parentID:String, point:Point, weight:Float, color:Color, alpha:Float){
        if (self.currentDrawing == nil){
            return
        }
        
        self.dirty = true
        
        self.currentDrawing!.addSegmentToStroke(parentID: parentID, point: point, weight: weight, color: color, alpha: alpha)
    }

    
    func hitTest(point:Point, threshold:Float, id:String)->Stroke?{
        
        let hit = currentDrawing!.hitTest(point: point,threshold:threshold, id: id)
        #if DEBUG
            //print("canvas hit test: \(String(describing: hit))");
        #endif

        if(hit != nil){
            return hit;
        }
       
        
        return nil;
    }
    
    func parentHitTest(point:Point, threshold:Float, id:String, parentId:String)->Stroke?{
        
        let hit = currentDrawing!.parentHitTest(point: point,threshold:threshold, id: id, parentId: parentId)
        #if DEBUG
            //print("canvas hit test: \(String(describing: hit))");
        #endif
        
        if(hit != nil){
            return hit;
        }
        
        
        return nil;
    }
    
    func drawingDataGenerated(data:(String), key:String){
        var string = "{\"canvas_id\":\""+self.id+"\","
        string += data;
        string += "}"
        self.transmitEvent.raise(data:(string));
    }
    
    
    
    
    //Event handlers
    //chains communication between brushes and view controller
    func drawHandler(data:(Geometry,String,String), key:String){
        self.geometryModified.raise(data:data)
    }
    
    
    
}


// MARK: Equatable
func ==(lhs:Canvas, rhs:Canvas) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}


