//
//  NavigationManager.swift
//  kargoTakip
//
//  Created by proje on 3.11.2022.
//

import Foundation
import UIKit

enum ControllerType {
    case loginVC
    case tabBarVC
}

class NavigationManager {
    
    static let shared = NavigationManager()
    
    func navigateTo(_ type: ControllerType) -> UIViewController {
        let vc = createVC(type)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        return vc
    }
    
    func createVC(_ type: ControllerType) -> UIViewController {
        switch type {
        case .loginVC:
            return loginVC
        case .tabBarVC:
            return tabBarVC
        }
    }
    
    // MARK: StoryBoards
    var mainStoryBoard : UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    var landingStoryBoard: UIStoryboard {
        return UIStoryboard(name: "Landing", bundle: nil)
    }
    
    
    // MARK: ViewControllers
    
    var loginVC: LoginVC {
        return mainStoryBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
    }
    var tabBarVC: TabbarController {
        return landingStoryBoard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
    }
    
}
