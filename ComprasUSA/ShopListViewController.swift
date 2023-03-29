//
//  ViewController.swift
//  ComprasUSA
//
//  Created by Gabriel Patane Todaro on 02/03/23.
//

import UIKit

class ShopListViewController: UIViewController {

  private let productCellId = "productCellIdentifier"

  @IBOutlet weak var shopTableView: UITableView!

  var productsMock = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()

    shopTableView.dataSource = self
    shopTableView.delegate = self
    shopTableView.register(ProductCell.self, forCellReuseIdentifier: productCellId)

    let addItemButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
    navigationItem.setRightBarButton(addItemButton, animated: true)
  }

  @objc
  private func addNewItem() {
//    productsMock.append("Item")
//    shopTableView.reloadData()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    guard let viewController = storyboard.instantiateViewController(withIdentifier: "productVCId") as? ItemViewController else {
      return
    }
    viewController.delegate = self
    navigationController?.pushViewController(viewController, animated: true)
  }

  private func deleteItem(at indexPath: IndexPath) {
    productsMock.remove(at: indexPath.row)
  }
}

extension ShopListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      deleteItem(at: indexPath)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    96
  }
}

extension ShopListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: productCellId, for: indexPath) as? ProductCell else {
      return UITableViewCell()
    }

    cell.setInfo(name: productsMock[indexPath.row], value: "0")
    return cell
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

extension ShopListViewController: ProductDelegate {
  func createProduct(_ product: Product) {

  }

  func editProduct(_ product: Product) {
    
  }
}
