//
//  SceneDelegate.swift
//  RxLibrary
//
//  Created by Tin Pham on 1/2/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let booksRepository = BooksRepository(remoteDataSource: OpenLibraryRemoteDataSource())
        let viewModel: BookListViewModelProtocol = BookListViewModel(booksRepository: booksRepository)
        let viewController = BookListViewController(viewModel: viewModel)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
