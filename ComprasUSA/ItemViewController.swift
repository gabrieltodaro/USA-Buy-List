//
//  ItemViewController.swift
//  ComprasUSA
//
//  Created by Gabriel Patane Todaro on 07/03/23.
//

import UIKit

class ItemViewController: UIViewController {

  @IBOutlet weak var productNameTextField: UITextField!
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var statePickerView: UITextField!
  @IBOutlet weak var addStateButton: UIButton!
  @IBOutlet weak var valueInDolarTextField: UITextField!
  @IBOutlet weak var addIOFButton: UISwitch!
  @IBOutlet weak var addButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
