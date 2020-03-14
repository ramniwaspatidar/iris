//
//  ECardViewController.swift
//  Iris
//
//  Created by Ramniwas Patidar on 29/02/20.
//  Copyright © 2020 apptology. All rights reserved.
//

import UIKit


@objc protocol delegateDownloadFinished {
    func saveDownloadFile(_ url : URL)
}
class ECardViewController: UIViewController,downloadStatusDelegate,URLSessionDelegate,URLSessionDownloadDelegate {
    
    var progressDelegate : downloadStatusDelegate?
    var defaultSession: URLSession!
    @objc var downloadTask: URLSessionDownloadTask!
    
    
    
    @objc var pdfUrl : String = ""
    @objc var downloadDelegate : delegateDownloadFinished?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var downloadTitle: UILabel!
    @IBOutlet weak var progressText: UILabel!
    @IBOutlet weak var remainigTimeLabel: UILabel!
    @IBOutlet weak var downlodSizeLabel: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var cancelButton : UIButton!
    @IBOutlet weak var hideButton : UIButton!
    
    var ecard : EcardModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPDFFile(pdfUrl)
        
        //        ecard = EcardModel()
        //        ecard?.progressDelegate = self
        //        ecard?.getPDFFile(pdfUrl)
        
        nameLabel.text = ""
        fromLabel.text = ""
        sizeLabel.text = "0"
        percentageLabel.text = "0"
        progressView.progress = 0
        setView()
    }
    
    @objc func getPDFFile(_ url : String){
        
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        defaultSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        downloadTask = defaultSession.downloadTask(with: URL(string: url)!)
        downloadTask.resume()
        
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if totalBytesExpectedToWrite > 0 {
            getDownloadStatus(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
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
            saveFile(savedURL)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setView(){
        
        progressText.text =  Localization.languageSelectedString(forKey: "Progress")
        downloadTitle.text = Localization.languageSelectedString(forKey: "Download")
        cancelButton.setTitle(Localization.languageSelectedString(forKey: "CANCEL"), for: .normal)
        hideButton.setTitle(Localization.languageSelectedString(forKey: "HIDE"), for: .normal)
        
        
        bgView.layer.masksToBounds = false
        bgView.layer.cornerRadius = 10
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        bgView.layer.shadowOpacity = 0.5
        bgView.layer.shadowRadius = 1.0
    }
    
    
    func getDownloadStatus(_ bytesWritten: Int64, _ totalBytesWritten: Int64, _ totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        let percentage = (totalBytesWritten * 100) / totalBytesExpectedToWrite
        
        percentageLabel.text = "\(percentage) %%%"
        
        let urlString = pdfUrl.replacingOccurrences(of: "http://demoiris.ezyclaim.com:8080/MobileApp/MobileApp/eCardPdf/", with: "")
        let str = urlString.replacingOccurrences(of: ".pdf", with: "")
        
        nameLabel.text = "\(Localization.languageSelectedString(forKey: "Name : "))" + str
        fromLabel.text = "\(Localization.languageSelectedString(forKey: "From : "))" + pdfUrl
        sizeLabel.text = "\(Units(bytes: totalBytesExpectedToWrite).getReadableUnit())"
        percentageLabel.text = "\(percentage)"
        progressView.progress = progress
        
        print(Units(bytes: totalBytesWritten).getReadableUnit())
        print(Units(bytes: totalBytesExpectedToWrite).getReadableUnit())
        
    }
    
    func saveFile(_ url: URL) {
        self.navigationController?.popViewController(animated: true)
        downloadDelegate?.saveDownloadFile(url)
    }
    @IBAction func cancelButtonAction(_ sender: Any) {
        //EcardModel.btnStopPressed();
        //        ecard?.downloadTask.cancel()
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func hideButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}

extension ECardViewController{
    
    public struct Units {
        
        public let bytes: Int64
        
        public var kilobytes: Double {
            return Double(bytes) / 1_024
        }
        
        public var megabytes: Double {
            return kilobytes / 1_024
        }
        
        public var gigabytes: Double {
            return megabytes / 1_024
        }
        
        public init(bytes: Int64) {
            self.bytes = bytes
        }
        
        public func getReadableUnit() -> String {
            
            switch bytes {
            case 0..<1_024:
                return "\(bytes) bytes"
            case 1_024..<(1_024 * 1_024):
                return "\(String(format: "%.2f", kilobytes)) kb"
            case 1_024..<(1_024 * 1_024 * 1_024):
                return "\(String(format: "%.2f", megabytes)) mb"
            case (1_024 * 1_024 * 1_024)...Int64.max:
                return "\(String(format: "%.2f", gigabytes)) gb"
            default:
                return "\(bytes) bytes"
            }
        }
    }
}
