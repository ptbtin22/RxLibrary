//
//  BookListViewController.swift
//  RxLibrary
//
//  Created by Tin Pham on 1/2/26.
//

import UIKit
import Combine
import RxSwift
import RxCocoa

class BookListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: BookListViewModelProtocol
    private var books: [Book] = []
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
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
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
    
    init(viewModel: BookListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal

extension BookListViewController {
    func configureView(with books: [Book]) {
        self.books = books
        tableView.reloadData()
    }
}

// MARK: - Private

extension BookListViewController {
    private func setupViews() {
        tableView.register(BookCell.self, forCellReuseIdentifier: "BookCell")
        
        view.backgroundColor = .systemGray6
        view.addSubview(logoImageView)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            
            searchBar.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func setupBindings() {
        searchBar.rx.text
            .bind(to: viewModel.searchInput)
            .disposed(by: disposeBag)
        
        viewModel.state
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                guard let self else { return }
                switch state {
                case .loading:
                    let spinner = UIActivityIndicatorView(style: .medium)
                    spinner.startAnimating()
                    self.tableView.tableFooterView = spinner
                    self.tableView.tableFooterView?.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 44)
                case .success(let books):
                    self.tableView.tableFooterView = nil
                    self.books = books
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

extension BookListViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookCell else {
            return UITableViewCell()
        }
        let book = books[indexPath.row]
        let isLast = indexPath.row == books.count - 1
        cell.configure(with: book, isLast: isLast)
        return cell
    }
}
