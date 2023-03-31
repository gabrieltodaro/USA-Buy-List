//
//  Double.swift
//  ComprasUSA
//
//  Created by Gabriel Patane Todaro on 30/03/23.
//

import Foundation

extension Double {
  /// Rounds the double to decimal places value
  func rounded(toPlaces places:Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
}
