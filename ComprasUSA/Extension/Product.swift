//
//  Product.swift
//  ComprasUSA
//
//  Created by Gabriel Patane Todaro on 02/04/23.
//

import UIKit

extension Product {
  var unloadedImage: UIImage? {
    if let imageData {
      return UIImage(data: imageData)
    } else {
      return UIImage(named: "ProductPlaceholder")
    }
  }
}
