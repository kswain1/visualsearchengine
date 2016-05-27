//
//  ViewController.swift
//  VSE
//
//  Created by Darian Nwankwo on 5/27/16.
//  Copyright © 2016 Darian Nwankwo. All rights reserved.
//

import UIKit
import Alamofire
import CloudSight

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CloudSightImageRequestDelegate, CloudSightQueryDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var myImage: UIImage?
    
    var camera : LLSimpleCamera!
    
    @IBOutlet weak var scrollContainerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let screenRect = UIScreen.mainScreen().bounds
        self.camera = LLSimpleCamera()
        self.scrollContainerView.addSubview(self.camera.view)
        self.camera.view.frame = screenRect
        self.addChildViewController(self.camera)
        self.camera.didMoveToParentViewController(self)

        self.scrollableHeightConstraint.constant = screenRect.height * 2
        self.activityIndicator.hidden = true
        self.titleLabel.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.camera.start()
    }
    
    @IBOutlet weak var scrollableHeightConstraint: NSLayoutConstraint!
    @IBAction func snapPressed(sender: AnyObject) {
        
        self.camera.capture { (camera, image, metadata, error) in
            self.myImage = image
            self.AlamoFireRequest()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var imagePicker: UIImagePickerController!
    @IBOutlet var imageView: UIImageView!
    @IBAction func takePhoto(sender: UIButton) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.myImage = imageView.image
        self.AlamoFireRequest()
        
    }
    
    // With Alamofire
//    func fetchAllRooms() {
//        
//        Alamofire.upload(
//            .POST,
//            "https://api.cloudsightapi.com//image_requests",
//            headers: ["Authorization" : "CloudSight [n2o53offxe1q5WJC4Dzm0Q]"],
//            multipartFormData: { multipartFormData in
//                multipartFormData.appendBodyPart(data: self.myImage!, name: "imagefile",
//                    fileName: "image.jpg", mimeType: "image/jpeg")
//            },
//            encodingCompletion: { encodingResult in
//            
//            }
//    }
    
        
        func AlamoFireRequest () {
        
            
            CloudSightConnection.sharedInstance().consumerKey = "n2o53offxe1q5WJC4Dzm0Q"
            CloudSightConnection.sharedInstance().consumerSecret = "g_eBushHVJmxtuKPBPSCaw"
            
            self.searchWithImage(self.myImage!)
            
//            Alamofire.request(.POST, "http://cloudsightapi.com/image_requests/", headers: ["Authorization":"CloudSight n2o53offxe1q5WJC4Dzm0Q",] ,parameters: ["image_request[image]": self.myImage!, "image_request[locale]":"en-US", "Secret":"g_eBushHVJmxtuKPBPSCaw", "API Key":"n2o53offxe1q5WJC4Dzm0Q"])
//                .responseJSON { response in
//                    print(response.request)  // original URL request
//                    print(response.response) // URL response
//                    print(response.data)     // server data
//                    print(response.result)   // result of response serialization
//                    
//                    if let JSON = response.result.value {
//                        print("JSON: \(JSON)")
//                    }
//            }
        }
    
    var cloudQuery : CloudSightQuery?
    func searchWithImage(image: UIImage) {
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
            let deviceIdentifier: String = "923d2c2263sacaid7"
            // This can be any unique identifier per device, and is optional - we like to use UUIDs
            let location: CLLocation = CLLocation(latitude: 51, longitude: 14)
            // you can use the CLLocationManager to determine the user's location
            // We recommend sending a JPG image no larger than 1024x1024 and with a 0.7-0.8 compression quality,
            // you can reduce this on a Cellular network to 800x800 at quality = 0.4
            let imageData: NSData = UIImageJPEGRepresentation(image, 0.7)!
            // Create the actual query object
            let query: CloudSightQuery = CloudSightQuery(image: imageData, atLocation: CGPointZero, withDelegate: self, atPlacemark: location, withDeviceId: deviceIdentifier)
            // Start the query process
            query.start()
            self.cloudQuery = query
        }
    
    // MARK: - CloudSightImageRequestDelegate
    
    func cloudSightRequest(sender: CloudSightImageRequest!, didFailWithError error: NSError!) {
        
    }
    
    func cloudSightRequest(sender: CloudSightImageRequest!, didReceiveToken token: String!, withRemoteURL url: String!)
    {
        
    }
    
    // MARK: - CloudSightQueryDelegate
    
    @IBOutlet weak var titleLabel: UILabel!
    func cloudSightQueryDidFinishIdentifying(query: CloudSightQuery!) {
        if query.title != nil {
            print(query.title)
            self.titleLabel.text = query.title
        }
        self.activityIndicator.hidden = true
        self.titleLabel.hidden = false
        self.activityIndicator.stopAnimating()
    }
    
    func cloudSightQueryDidFail(query: CloudSightQuery!, withError error: NSError!) {
        print(error)
        self.activityIndicator.hidden = true
        self.activityIndicator.stopAnimating()
    }
    
//        
//        Alamofire.request(
//            .GET,
//            "http://localhost:5984/rooms/_all_docs",
//            parameters: ["include_docs": "true"],
//            encoding: .URL)
//            .validate()
//            .responseJSON { (response) -> Void in
//                guard response.result.isSuccess else {
//                    print("Error while fetching remote rooms: \(response.result.error)")
//                    completion(nil)
//                    return
//                }
//                
//                guard let value = response.result.value as? [String: AnyObject],
//                    rows = value["rows"] as? [[String: AnyObject]] else {
//                        print("Malformed data received from fetchAllRooms service")
//                        completion(nil)
//                        return
//                }
//                
//                var rooms = [RemoteRoom]()
//                for roomDict in rows {
//                    rooms.append(RemoteRoom(jsonData: roomDict))
//                }
//                
//                completion(rooms)
//        }
//    }
}

