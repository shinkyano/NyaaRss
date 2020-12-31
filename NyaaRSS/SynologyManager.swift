//
//  SynologyManager.swift
//  NyaaRSS
//
//  Created by Hervé PIERRE on 27/12/2020.
//

import Foundation

class SynologyManager  {
    
    let synologyIP = "192.168.1.22"
    let synologyPort = "5000"
    let synologyLogin = "shinkyano"
    let synologyPassword = "Kyano62378"
    
    var synologyServices: SynologyServices? = nil
    
    var toto: SynologyServices?
    var login: SynologyLogin?
    var downloadTask: SynologyDownloadTask?
    
    func download(torrent: String) {
        getSynologyServices()
        if let x = toto {
            print(x.success)
            let authVersion: String = String(x.data.synoAPIAuth.maxVersion)
            let downloadStationVersion: String = String(x.data.synoDownloadStationTask.maxVersion)
            
            login(authVersion)
            
            if let y = login {
                print(y.data.sid)
                
                let torrent =  torrent.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                createTask(torrent: torrent, downloadStationVersion: downloadStationVersion)
                
                if let z = downloadTask {
                    print(torrent)
                } else {
                    print("Erreur lors de la création de la tache")
                }
                
            }
            
        }
    }
    
    // MARK: - Services list
    
    func getSynologyServices(){
        let synologyURL = "http://\(synologyIP):\(synologyPort)/webapi/query.cgi?api=SYNO.API.Info&version=1&method=query&query=SYNO.API.Auth,SYNO.DownloadStation.Task"
        performRequest(with: synologyURL, step: "getInfos")
    }
    
    func login(_ authVersion: String){
        
        let synologyURL = "http://\(synologyIP):\(synologyPort)/webapi/auth.cgi?api=SYNO.API.Auth&version=\(authVersion)&method=login&account=\(synologyLogin)&passwd=\(synologyPassword)&session=DownloadStation&format=cookie"
        
        performRequest(with: synologyURL, step: "login")
        
    }
    
    func createTask(torrent: String, downloadStationVersion: String){
        let synologyURL = "http://192.168.1.22:5000/webapi/DownloadStation/task.cgi?api=SYNO.DownloadStation.Task&version=\(downloadStationVersion)&method=create&uri=\(torrent)"
        performRequest(with: synologyURL, step: "createTask")
    }
    
    func performRequest(with urlString: String, step: String) {
        
        //1.Create a URL
        if let url = URL(string: urlString){
            
            //2.Create a URL session
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            //3.Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    //                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(safeData, step: step)
                }
                
            }
            
            //4.Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ synologyData: Data, step: String) {
        let decoder = JSONDecoder()
        
        do {
            
            switch step {
            case "getInfos":
                let decodedData = try decoder.decode(SynologyServices.self, from: synologyData)
                toto = decodedData
            case "login":
                let decodedData = try decoder.decode(SynologyLogin.self, from: synologyData)
                login = decodedData
            case "createTask":
                let decodedData = try decoder.decode(SynologyDownloadTask.self, from: synologyData)
                downloadTask = decodedData
            default:
                break
            }
            
        } catch {
            print(error)
        }
    }
    
    
    
}
