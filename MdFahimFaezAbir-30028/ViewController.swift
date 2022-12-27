//
//  ViewController.swift
//  MdFahimFaezAbir-30028
//
//  Created by Bjit on 20/12/22.
//

import UIKit


class ViewController: UIViewController {
    // MARK: - Class Veriable
    var jsonObj: [String: Any] = [:]
    var fileManager = FileManager.default
    var folderUrl: URL?
    var fileUrls: URL?
    var message: [String]?
    var imageArray: [String]?
    var imageUrl: URL?
    var flag = true
    var indexPath: IndexPath?
    
    // MARK: - Outlet
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textInput: UITextView!
    
    
    // MARK: - Execution Start
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.cornerRadius = 20
        textInput.layer.borderWidth = 1
        textInput.layer.borderColor = UIColor.systemBlue.cgColor
        textInput.layer.cornerRadius = 15
        
        //createFileManager()
        tableView.delegate = self
        tableView.dataSource = self
        ///textInput.layer.borderColor = UIColor.systemPink.cgColor
        //textInput.layer.cornerRadius = 5
        createFileManager()
        createFolder()
        showTextFile()
        createImageDirectory()
    }
    
    // MARK: - Image Save
    func createImageDirectory(){
        guard let documentUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        
        imageUrl = documentUrl.appendingPathComponent("imageFolder")
        //print(imageUrl?.path)
        if let imageUrl = imageUrl {
            do {
                try fileManager.createDirectory(at: imageUrl, withIntermediateDirectories: true)
            }catch{
                print(error)
            }
        }
        
    }
    
    // MARK: - Show Image from Local Directory
    func saveImage(){
        //var imageToReturn: UIImage?
        if let imageUrl = imageUrl {
            let imageFile = imageUrl.appendingPathComponent("skyler.png")
            let  image = UIImage(named: "skyler")
            fileManager.createFile(atPath: imageFile.path, contents: image?.pngData())
            
        }
    }
    func showImage()-> UIImage?{
        var imageToReturn: UIImage?
        if let imageUrl = imageUrl {
            print("Abir: \(imageUrl.path)")
            do {
                let readData  = try Data(contentsOf: imageUrl.appendingPathComponent("skyler.png"))
                print(readData)
                let images = UIImage(data: readData)
                imageToReturn = images
            }catch{
                print(error)
            }
        }
        // tableView.layer.borderColor = UIColor.black.cgColor
        return imageToReturn
    }
    
    
    // MARK: -
    func createFileManager(){
        
        guard let documentUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        
        folderUrl = documentUrl.appendingPathComponent("TextFolder")
        
    }
    func createFolder(){
        do {
            if let url = folderUrl{
                try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
            }
        } catch {
            print(error)
        }
    }
    func  showTextFile(){
        if let folderUrl = folderUrl {
            do {
                try   message = fileManager.contentsOfDirectory(atPath: folderUrl.path)
            }catch{
                print(error)
            }
        }
    }
    func  createTextFile(){
        if let folderUrl = folderUrl{
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dates = formatter.string(from: date)
            
            fileUrls = folderUrl.appendingPathComponent("text "+dates+".txt")
            if textInput.text != ""{
                let text = textInput.text
                fileManager.createFile(atPath: fileUrls!.path, contents: text?.data(using: .utf8))
                do {
                    try   message = fileManager.contentsOfDirectory(atPath: folderUrl.path)
                    //print(message)
                }catch{
                    print(error)
                }
                tableView.reloadData()
            }
        }
        
    }
//    func changeBg(_ sender: Any) {
//        createImageDirectory()
//        saveImage()
//    }
//    func textSave(_ sender: Any) {
//        createTextFile()
//    }
    @IBAction func changeBG(_ sender: Any) {
        createImageDirectory()
        saveImage()
    }
    
    @IBAction func textSave(_ sender: Any) {
        createTextFile()
    }
    
    @IBAction func editAction(_ sender: Any) {
        
    }
    
    @IBAction func deleteAction(_ sender: Any){
        
    }
    func showfile(row: Int)-> String{
        var readStr = ""
        if var message = message, let  url = folderUrl{
            message.sort()
            message = message.reversed()
            let urls = url.appendingPathComponent(message[row])
            do {
                let readData  = try Data(contentsOf: urls)
                if let str = String(data: readData, encoding: .utf8){
                    readStr = str
                }
                print(readStr)
            }catch{
                print(error)
            }
        }
        
        //   print(readStr)
        return readStr
        
    }
    
    
}
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let cnt = message?.count{
            count = cnt
            print(count)
        }
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "firstSection", for: indexPath) as! FirstSection
        // tableView.beginUpdates()
        cell.labelView.text = showfile(row: indexPath.row)
        cell.imagesSet.image = showImage()
        //tableView.endUpdates()
        cell.layer.cornerRadius = 5
        //tableView.reloadData()
        return cell
        
    }
    
    
}
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

