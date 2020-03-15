//
//  Router.swift
//  NPCEO
//
//  Created by  Artem Mazheykin on 13.03.2020.
//  Copyright © 2020 Artem Mazheykin. All rights reserved.
//

import UIKit

protocol Router: class {
    func presentViewController(nextViewController: UIViewController) -> UIViewController
    func pushViewController(nextViewController: UIViewController) -> UIViewController
}
