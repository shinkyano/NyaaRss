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
    
    var synologyServices: SynologyServices?
    var login: SynologyLogin?
    var logoutVariable: SynologyLogout?
    var downloadTask: SynologyDownloadTask?
    
    var authVersion: String = ""
    var downloadStationVersion: String = ""
    
    func download(torrent: String) {
        
        print("toto")
        let synologyURL = "http://\(self.synologyIP):\(self.synologyPort)/webapi/query.cgi?api=SYNO.API.Info&version=1&method=query&query=SYNO.API.Auth,SYNO.DownloadStation.Task"
        
        //1.Create a URL
        if let url = URL(string: synologyURL){
            
            //2.Create a URL session
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            //3.Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    return
                }
                
                if let safeData = data {
                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(SynologyServices.self, from: safeData)
                        self.synologyServices = decodedData
                        login()
                    } catch {
                        print(error)
                    }
                }
                
            }
            
            //4.Start the task
            task.resume()
        }
        
        func login() {
            print("tata")
            if let x = self.synologyServices {
                print(x.success)
                authVersion = String(x.data.synoAPIAuth.maxVersion)
                downloadStationVersion = String(x.data.synoDownloadStationTask.maxVersion)
                
                let synologyURL = "http://\(synologyIP):\(synologyPort)/webapi/auth.cgi?api=SYNO.API.Auth&version=\(authVersion)&method=login&account=\(synologyLogin)&passwd=\(synologyPassword)&session=DownloadStation&format=cookie"
                
                //1.Create a URL
                if let url = URL(string: synologyURL){
                    
                    //2.Create a URL session
                    let session = URLSession(configuration: URLSessionConfiguration.default)
                    
                    //3.Give the session a task
                    let task = session.dataTask(with: url) { (data, response, error) in
                        if error != nil{
                            return
                        }
                        
                        if let safeData = data {
                            do {
                                let decoder = JSONDecoder()
                                let decodedData = try decoder.decode(SynologyLogin.self, from: safeData)
                                self.login = decodedData
                                
                                if let y = self.login {
                                    print(y.data.sid)
                                    createTask(self.downloadStationVersion)
                                } else {
                                    print("Could not log in")
                                }
                                
                            } catch {
                                print(error)
                            }
                        }
                        
                    }
                    
                    //4.Start the task
                    task.resume()
                    
                } else {
                    print("pas succes")
                }
            }
            
            func createTask(_ downloadStationVersion: String) {
                let synologyURL = "http://\(self.synologyIP):\(self.synologyPort)/webapi/DownloadStation/task.cgi?api=SYNO.DownloadStation.Task&version=\(downloadStationVersion)&method=create&uri=\(torrent)"
                
                //1.Create a URL
                if let url = URL(string: synologyURL){
                    
                    //2.Create a URL session
                    let session = URLSession(configuration: URLSessionConfiguration.default)
                    
                    //3.Give the session a task
                    let task = session.dataTask(with: url) { (data, response, error) in
                        if error != nil{
                            logout()
                            return
                        }
                        
                        if let safeData = data {
                            do {
                                let decoder = JSONDecoder()
                                let decodedData = try decoder.decode(SynologyDownloadTask.self, from: safeData)
                                self.downloadTask = decodedData
                                
                                if let z = self.downloadTask {
                                    if z.success == true {
                                        print("task OK")
                                    }
                                } else {
                                    print("Could not create task")
                                }
                                
                            } catch {
                                print(error)
                            }
                            logout()
                        }
                        
                    }
                    
                    //4.Start the task
                    task.resume()
                    
                }
                
            }
            
            
            func logout() {
                let synologyURL = "http://\(self.synologyIP):\(self.synologyPort)/webapi/auth.cgi?api=SYNO.API.Auth&version=\(authVersion)&method=logout&session=DownloadStation"
                
                
                //1.Create a URL
                if let url = URL(string: synologyURL){
                    
                    //2.Create a URL session
                    let session = URLSession(configuration: URLSessionConfiguration.default)
                    
                    //3.Give the session a task
                    let task = session.dataTask(with: url) { (data, response, error) in
                        if error != nil{
                            print("error during logout")
                            return
                        }
                        
                        if let safeData = data {
                            do {
                                let decoder = JSONDecoder()
                                let decodedData = try decoder.decode(SynologyLogout.self, from: safeData)
                                self.logoutVariable = decodedData
                                
                                if let z = self.logoutVariable {
                                    if z.success == true {
                                        print("logout OK")
                                    }
                                } else {
                                    print("Could not logout")
                                }
                                
                            } catch {
                                print(error)
                            }
                        }
                        
                    }
                    
                    //4.Start the task
                    task.resume()
                    
                }
            }
            
        }
    }
}
