//
//  SceneDelegate.swift
//  Weather
//
//  Created by Daniil Rassadin on 14/3/24.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let networkService = OpenWeatherNetworkService()
        let model = OpenWeatherModel(networkService: networkService)
        let currentWeatherVC = CurrentWeatherVC(model: model)
        window?.rootViewController = currentWeatherVC
        window?.makeKeyAndVisible()
    }

}

