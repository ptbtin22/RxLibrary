//
//  ViewController.swift
//  RxLibrary
//
//  Created by Tin Pham on 1/2/26.
//

import UIKit
import Combine
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: ViewModelProtocol
    private var titles: [String] = []
    private let disposeBag = DisposeBag()
    
    // MARK: - UI
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "AppLogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search for books..."
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupBindings()
    }
    
    // MARK: - Initializers
    
    init(viewModel: ViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal

extension ViewController {
    func configureView(with titles: [String]) {
        self.titles = titles
        tableView.reloadData()
    }
}

// MARK: - Private

extension ViewController {
    private func setupViews() {
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "MyTableViewCell")
        
        view.addSubview(logoImageView)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            
            searchBar.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        // Here we'd bind searchBar.rx.text to viewModel input
        // For now, retaining original bindings logic
        
        viewModel.state
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading:
                    let spinner = UIActivityIndicatorView(style: .medium)
                    spinner.startAnimating()
                    self.tableView.tableFooterView = spinner
                    self.tableView.tableFooterView?.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 44)
                    
                case .success(let titles):
                    self.tableView.tableFooterView = nil
                    self.titles = titles
                    self.tableView.reloadData()
                    
                case .error(let error):
                    self.tableView.tableFooterView = nil
                    print("Error: \(error.localizedDescription)")
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableView

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as? MyTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        cell.configure(with: title)
        return cell
    }
}

