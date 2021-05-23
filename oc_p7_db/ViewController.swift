//
//  ViewController.swift
//  oc_p7_db
//
//  Created by Gilles Sagot on 17/05/2021.
//

import Cocoa
import Darwin


class ViewController: NSViewController {
    
    var _user : String = ""
    var _pwd : String = ""
    var _adress : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        authentication ()

     }
    

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    func handlePlayerInput () -> String {
        var input = String(bytes:FileHandle.standardInput.availableData, encoding: .utf8)!
        input = input.trimmingCharacters(in: .whitespacesAndNewlines)
        return input

    }
    
    
    func authentication ()
    {
        print("please enter a user to connect oc_pizza :")
        _user = handlePlayerInput()
        print("password : ")
        _pwd = handlePlayerInput()
        connect(user:_user ,pwd:_pwd)
    }
    
    func getAdressFromFile()->Bool {
        // Do any additional setup after loading the view.
        let file = "file.txt"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            do {
                    _adress = try String(contentsOf: fileURL, encoding: .utf8)
                return true
               }
               catch { return false }
        }
        return false
        
    }
    
    func connect(user:String, pwd:String) {
        var url:URL?
        // Do any additional setup after loading the view.
        if getAdressFromFile(){
            url = URL(string: _adress + "link.php")
        }
        else {
            print("Add URL file in document")
        }
        if url != nil{
        var request = URLRequest(url: url!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "&adress=localhost:3306"+"&user=\(user)"+"&pwd=\(pwd)"+"&db=oc_pizza";

        //adding the parameters to request body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)

        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                  // print("error=\(error)")
                   return
            }
            //print("response = \(String(describing: response))")
            do {
                //converting resonse to NSDictionary
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed) as? NSArray
                //parsing the json
                if let parseJSON = myJSON {
                    //creating a string
                    var msg : String!
                    //getting the json response
                    for i in 0..<myJSON!.count {
                        msg = parseJSON[i] as! String?
                        print (msg!)
                    }
                    if msg == "Connexion impossible" {
                        self.authentication()
                    }
                    else {
                        self.request()
                    }
                }
                
                } catch {
                print(error)
                }
        }
        task.resume()
        }else{
            print ("Can not connect to localhost server : URL not valid")
        }
    }
    
    
    func request() {
        let url = URL(string: _adress + "request.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        print ("")
        print ("Commande SQL ?")
        let sql = handlePlayerInput()
        //"SELECT name FROM ingredient"
        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "&adress=localhost:3306"+"&user=\(_user)"+"&pwd=\(_pwd)"+"&db=oc_pizza"+"&sql=\(sql)";

        //adding the parameters to request body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)

        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                  // print("error=\(error)")
                   return
            }
            //print("response = \(String(describing: response))")
            do {
                //converting resonse to NSDictionary
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed) as? NSArray
                //parsing the json
                if let parseJSON = myJSON {
                    //creating a string
                    var msg : String!
                    //getting the json response
                    for i in 0..<myJSON!.count {
                        msg = parseJSON[i] as! String?
                        print (msg!)
                    }
                }
                self.request()
                
                } catch {
                print(error)
                }
        }
        task.resume()
        
        
    }


}

