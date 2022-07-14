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
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(
            ServicesTableViewCell.self,
            forCellReuseIdentifier: ServicesTableViewCell.identifier
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupUI()
        setupServices()
    }
    
    
    // MARK: - Private Methods
    
    private func setupUI() {
        title = "Сервисы VK"
        navigationItem.largeTitleDisplayMode = .always
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupServices() {
        guard checkRechability() else { return }
        APICaller.shared.fetchServices { [weak self] results in
            DispatchQueue.main.async {
                switch results {
                case .success(let result):
                    self?.services = result.body.services
                    self?.tableView.reloadData()
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

// MARK: -  UITableViewDelegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let url = URL(string: services[indexPath.row].link) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Не удается открыть вебсайт или приложение", preferredStyle: .alert)
            let action = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ServicesTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: ServicesTableViewCell.identifier,
            for: indexPath
        ) as? ServicesTableViewCell else { return UITableViewCell() }
        cell.setupCell(with: services[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
}
