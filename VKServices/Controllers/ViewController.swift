//
//  ViewController.swift
//  VKServices
//
//  Created by Dinar Garaev on 13.07.2022.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Public Properties
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: - Private Properties
    
    private var services = [Service]()
    
    private let tableView: UITableView = {
        let tabletView = UITableView()
        tabletView.backgroundColor = .clear
        tabletView.translatesAutoresizingMaskIntoConstraints = false
        return tabletView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUI()
        setupServices()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        title = "Сервисы VK"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupServices() {
        guard checkRechability() else { return }
        APICaller.shared.fetchServices { [weak self] results in
            DispatchQueue.main.async {
                switch results {
                case .success(let result):
                    self?.services = result.body.services
                    // reloadData
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func checkRechability() -> Bool {
        guard Reachability.isConnectedToNetwork() else {
            let alert = UIAlertController(title: "Ошибка", message: "Нет соединения", preferredStyle: .alert)
            let action = UIAlertAction(title: "Перезагрузить", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
}

