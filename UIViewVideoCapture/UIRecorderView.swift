//
//  UIRecorderView.swift
//  SparkleSend
//
//  Created by Joshua Teitelbaum on 6/13/20.
//  Copyright © 2020 sparklesparklesparkle. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Photos

let FPS = 24.0

class UIRecorderView {
    var writer:UIRecorderWriter!
    var events:UIRecorderViewEvents
    let queue = DispatchQueue.global(qos: .utility)
    var timer:DispatchSourceTimer?
    var view:UIView!
    var saveToVideoLibrary:Bool
    
    /**
     Initialization: Input view you want to capture, and the event listener that will let you know: completion or failboat :)
     */
    init(view:UIView, events:UIRecorderViewEvents, saveToVideoLibrary:Bool) {
        writer = UIRecorderWriter(events:events)
        self.events = events
        self.view = view
        self.saveToVideoLibrary = saveToVideoLibrary
    }
    
    func imageWithView(view: UIView) -> UIImage? {
        DispatchQueue.main.sync {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
        }
    }
    
    /**
     startRecordingView: 🟢
     */
    func startRecordingView() {
        writer.startDate = NSDate()
        writer.size = view.frame.size
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer!.schedule(deadline: .now(), repeating: 1.0 / FPS, leeway: .seconds(0))
        timer!.setEventHandler(handler: {
            let img = self.imageWithView(view: self.view)
            if(img != nil) {
                self.writer.write(img: img!.copy() as! UIImage)
            }
        })
        timer!.resume()
    }
    /**
     stopRecordingView:  🛑
     */
    func stopRecordingView() {
        timer!.cancel()
        writer.endDate = NSDate()
        writer.writeVideoFromImageFrames(saveToVideoLibrary: saveToVideoLibrary)
    }
}
