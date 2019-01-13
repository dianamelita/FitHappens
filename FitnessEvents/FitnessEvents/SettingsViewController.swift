//
//  SettingsViewController.swift
//  FitnessEvents
//
//  Created by Diana Ivascu on 11/28/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import UIKit
import MessageUI
import Service

class SettingsViewController: UIViewController {

    var service: Service!
    
    @IBOutlet private weak var tableView: UITableView!

    private var settingsOptions = [Option]()
    private var loginOrLogout = String()
    
    private enum Option {
        
        case decorated(UIImage, String)
        case simple(String)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        if let aboutImage = UIImage(named: "question") {
            
            settingsOptions.append(.decorated(aboutImage, "About the app"))
        }
        
        if let mailImage = UIImage(named: "mail") {
            
            settingsOptions.append(.decorated(mailImage, "Send us feedback"))
        }
    }
    
    private func presentMailViewController(subject: String, recipients: [String]) {
        
        if MFMailComposeViewController.canSendMail() {
            
            let mailComposerVC = MFMailComposeViewController()
            
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients(recipients)
            mailComposerVC.setSubject(subject)
            present(mailComposerVC, animated: true, completion: nil)
            
        } else {
            let emailErrorMessage = """
                                    Unable to send email. \n
                                    Please check your email settings and try again.
                                    """
            let sendMailErrorAlert = UIAlertController.init(title: "Error",
                                                            message: emailErrorMessage,
                                                            preferredStyle: .alert)
            
            sendMailErrorAlert.addAction(UIAlertAction.init(title: "OK",
                                                            style: .default,
                                                            handler: nil))
            
            present(sendMailErrorAlert, animated: true, completion: nil)
        }
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return settingsOptions.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        
        if indexPath.row == 2 {
            
            tableCell.imageView?.image = UIImage(named: "login")
            
            if let user = service.authentication.currentUser {
                
                tableCell.textLabel?.text = "Logout \(user)"
            } else {
                
                tableCell.textLabel?.text = "Login"
            }
            return tableCell
        }
        
        let option = settingsOptions[indexPath.row]
        
        switch option {
            
        case .decorated(let image, let title):
            
            tableCell.imageView?.image = image
            tableCell.textLabel?.text = title
            
        case .simple(let title):
            
            tableCell.textLabel?.text = title
        }
        return tableCell
    }
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch indexPath.row {
            
        case 0:
            
            performSegue(withIdentifier: "aboutSegue", sender: self)
            
        case 1:
            
            let subject = "Feedback for \(Bundle.main.displayName ?? "")"
            let recipients = ["dezso.diana91@gmail.com"]
            presentMailViewController(subject: subject, recipients: recipients)
            
        case 2:
            
            if service.authentication.currentUser == nil {
                
                service.authentication.authenticate { (success) in
                    
                    if success {
                        
                        DispatchQueue.main.async {
                            
                            tableView.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                }
            } else {
                
                service.authentication.logout()
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            
        default:
            return
        }
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                                 didFinishWith result: MFMailComposeResult,
                                 error: Error?) {
        
        switch (result) {
            
        case .cancelled,
             .sent:
            dismiss(animated: true, completion: nil)
       
        case .failed:
            dismiss(animated: true, completion: {
                let emailError = """
                                    Unable to send email. \n
                                    Please check your email settings and try again.
                                 """
                let sendMailErrorAlert = UIAlertController.init(title: "Failed",
                                                                message: emailError,
                                                                preferredStyle: .alert)
                sendMailErrorAlert.addAction(UIAlertAction.init(title: "OK",
                                                                style: .default,
                                                                handler: nil))
                self.present(sendMailErrorAlert, animated: true, completion: nil)
            })
        default:
            break
        }
    }
}
