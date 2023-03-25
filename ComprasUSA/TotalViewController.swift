//
//  TotalViewController.swift
//  ComprasUSA
//
//  Created by Gabriel Patane Todaro on 07/03/23.
//

import UIKit

class TotalViewController: UIViewController {

  @IBOutlet weak var usdTotalLabel: UILabel!
  @IBOutlet weak var brlTotalLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    usdTotalLabel.text = "No Items yet"
    brlTotalLabel.text = "No Items yet"
  }
}
