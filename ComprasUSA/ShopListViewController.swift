//
//  ViewController.swift
//  ComprasUSA
//
//  Created by Gabriel Patane Todaro on 02/03/23.
//

import UIKit

class ShopListViewController: UIViewController {

  @IBOutlet weak var shopTableView: UITableView!

  let productsMock: Array<String> = []

  override func viewDidLoad() {
    super.viewDidLoad()

    shopTableView.dataSource = self
    shopTableView.delegate = self

    let addItemButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
    navigationItem.setRightBarButton(addItemButton, animated: true)
  }

  @objc
  private func addNewItem() {
    print("add new item")
  }
}

extension ShopListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

  }
}

extension ShopListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if productsMock.count == 0 {
      shopTableView.setEmptyMessage("Your shop list is empty.\nAdd a new item using the + button above.")
    } else {
      shopTableView.restore()
    }

    return productsMock.count
  }
}
