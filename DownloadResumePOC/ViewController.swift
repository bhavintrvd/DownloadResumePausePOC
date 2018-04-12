//
//  ViewController.swift
//  DownloadResumePOC
//
//  Created by ios on 12/04/18.
//  Copyright © 2018 ios. All rights reserved.
//

import UIKit

class ViewController: UIViewController , URLSessionDownloadDelegate {
    
    var downloadTask : URLSessionDownloadTask?
    @IBAction func btnResumeTerminatedDownloadTapped(_ sender: Any) {
         if let downloadTas = downloadTask {
         downloadTas.cancel(byProducingResumeData: { (data) in
         if let data = data {
         print("data is \(data)")
            UserDefaults.standard.set(data, forKey: downloadTas.taskDescription!)
         }
         })
         }
    }
    
    
    @IBAction func btnResumeSuspendedDownloadTapped(_ sender: Any) {
        downloadTask?.resume()
    }
    
    @IBAction func btnSuspendDownloadTapped(_ sender: Any) {
        downloadTask?.suspend()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let config = URLSessionConfiguration.background(withIdentifier: "BackgroundSession")
        let urlSession = URLSession.init(configuration: config, delegate: self as URLSessionDownloadDelegate, delegateQueue: OperationQueue.main)
        let request = URLRequest.init(url: URL.init(string: "https://s3-us-west-2.amazonaws.com/tyunamitest/videos/10802/33f2321dc4a3e334f9ce0ff3599b39dd.mp4")!)
        
        let data = UserDefaults.standard.value(forKey: "storeData") as? Data
        if let dat = data {
            //            downloadTask = urlSession.downloadTask(withResumeData: dat)
            downloadTask = urlSession.downloadTask(withResumeData: dat)
            downloadTask?.resume()
            
        }
        else {
            downloadTask = urlSession.downloadTask(with: request)
            downloadTask?.taskDescription = "downloadTask"
            downloadTask?.resume()
        }
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        print("Finished downloading to \(location).")
        UserDefaults.standard.removeObject(forKey: downloadTask.taskDescription!)
        UserDefaults.standard.synchronize()
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("bytes re \(bytesWritten) \(totalBytesWritten) \(totalBytesExpectedToWrite)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

