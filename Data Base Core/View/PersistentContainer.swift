//
//  PersistentContainer.swift
//  Data Base Core
//
//  Created by Виталий Сосин on 30.06.2020.
//  Copyright © 2020 Vitalii Sosin. All rights reserved.
//

import UIKit

class PersistentContainer {
    
   static  let shared = PersistentContainer()
    
    let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init() {}
    
}
