//
//  DownloadECard.swift
//  Iris
//
//  Created by Ramniwas Patidar on 28/02/20.
//  Copyright © 2020 apptology. All rights reserved.
//

import Foundation
import UIKit

protocol downloadStatusDelegate {
    func getDownloadStatus(_ bytesWritten: Int64,_ totalBytesWritten: Int64,_ totalBytesExpectedToWrite: Int64)
    func saveFile(_ path : URL)

}

@objc public class EcardModel : NSObject,URLSessionDownloadDelegate{
    
     var progressDelegate : downloadStatusDelegate?
    
    var defaultSession: URLSession!
    @objc var downloadTask: URLSessionDownloadTask!
    
    
   
     func btnResumePressed() {
        downloadTask.resume()
    }
    
     func btnStopPressed() {
        downloadTask.cancel()
    }
    
     func btnPausePressed() {
        downloadTask.suspend()
    }
    
    @objc func getPDFFile(_ url : String){
        
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        defaultSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        downloadTask = defaultSession.downloadTask(with: URL(string: url)!)
        downloadTask.resume()
    
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if totalBytesExpectedToWrite > 0 {
            progressDelegate?.getDownloadStatus(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
        }
    }
    
   
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        guard let httpResponse = downloadTask.response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
                print ("server error")
                return
        }
        do {
            let documentsURL = try
                FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: false)
            let savedURL = documentsURL.appendingPathComponent(
                "ecard.pdf")
            self.progressDelegate?.saveFile(savedURL)
            try FileManager.default.moveItem(at: location, to: savedURL)

        } catch {
            print ("file error: \(error)")
        }
    }
   
    
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        downloadTask = nil
        if (error != nil) {
            print("failed")

        }
        else {
            print("The task finished successfully")
        }
    }
}
