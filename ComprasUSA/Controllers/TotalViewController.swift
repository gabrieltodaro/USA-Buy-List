//
//  TotalViewController.swift
//  ComprasUSA
//
//  Created by Gabriel Patane Todaro on 07/03/23.
//

import CoreData
import UIKit

class TotalViewController: UIViewController {

  @IBOutlet weak var usdTotalLabel: UILabel!
  @IBOutlet weak var brlTotalLabel: UILabel!

  private var addedProducts = [Product]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchProducts()
    calculate()
  }
}

// MARK: - Private Methods
extension TotalViewController {
  private func fetchProducts() {
    let productsFetch: NSFetchRequest<Product> = Product.fetchRequest()

    do {
      let managedContext = CoreDataHelper.shared.managedContext
      let results = try managedContext.fetch(productsFetch)
      addedProducts = results
    } catch let error as NSError {
      print("Fetch error: \(error) description: \(error.userInfo)")
    }
  }

  private func calculate() {
    guard let dolarConversionString = UserDefaults.standard.string(forKey: UserDefaultsKeys.dolar.rawValue),
          let dolarConversation = Double(dolarConversionString),
          let iofString = UserDefaults.standard.string(forKey: UserDefaultsKeys.iof.rawValue),
          let iof = Double(iofString) else {
      return
    }

    var totalInBRL: Double = 0
    var totalInUSD: Double = 0

    for product in addedProducts {
      totalInUSD += product.price

      let stateTax = product.state?.tax ?? 0
      let brlTotalWithStateTax = product.price + ((product.price * stateTax) / 100)
      if product.usingCard {
        let valueWithIOF = brlTotalWithStateTax + ((brlTotalWithStateTax * iof) / 100)
        totalInBRL += valueWithIOF
      } else {
        totalInBRL += brlTotalWithStateTax
      }
    }

    usdTotalLabel.text = "US$ \(totalInUSD.rounded(toPlaces: 2))"

    let totalInBRLWithDolar = totalInBRL * dolarConversation
    brlTotalLabel.text = "R$ \(totalInBRLWithDolar.rounded(toPlaces: 2))"
  }
}
