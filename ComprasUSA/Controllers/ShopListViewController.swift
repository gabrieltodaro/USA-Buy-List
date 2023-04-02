//
//  ViewController.swift
//  ComprasUSA
//
//  Created by Gabriel Patane Todaro on 02/03/23.
//

import CoreData
import UIKit

class ShopListViewController: UITableViewController {

  private let productCellId = "productCellIdentifier"

  var products = [Product]()

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(ProductCell.self, forCellReuseIdentifier: productCellId)

    let addItemButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
    navigationItem.setRightBarButton(addItemButton, animated: true)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    getShopList()
    tableView.reloadData()
  }

  private func getShopList() {
    let productsFetch: NSFetchRequest<Product> = Product.fetchRequest()
    let sortByDate = NSSortDescriptor(key: #keyPath(Product.name), ascending: true)
    productsFetch.sortDescriptors = [sortByDate]

    do {
      let managedContext = CoreDataHelper.shared.managedContext
      let results = try managedContext.fetch(productsFetch)
      products = results
    } catch let error as NSError {
      print("Fetch error: \(error) description: \(error.userInfo)")
    }
  }

  @objc
  private func addNewItem() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    guard let viewController = storyboard.instantiateViewController(withIdentifier: "productVCId") as? ItemViewController else {
      return
    }
    viewController.delegate = self
    navigationController?.pushViewController(viewController, animated: true)
  }

  private func deleteItem(at indexPath: IndexPath) {
    CoreDataHelper.shared.managedContext.delete(products[indexPath.row])
    products.remove(at: indexPath.row)

    CoreDataHelper.shared.saveContext()
  }
}

extension ShopListViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    guard let viewController = storyboard.instantiateViewController(withIdentifier: "productVCId") as? ItemViewController else {
      return
    }
    viewController.delegate = self
    viewController.product = products[indexPath.row]
    viewController.indexPath = indexPath
    navigationController?.pushViewController(viewController, animated: true)
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      deleteItem(at: indexPath)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    96
  }
}

extension ShopListViewController {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: productCellId, for: indexPath) as? ProductCell else {
      return UITableViewCell()
    }

    cell.setInfo(with: products[indexPath.row])
    return cell
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if products.count == 0 {
      tableView.setEmptyMessage("Sua lista está vazia!")
    } else {
      tableView.restore()
    }

    return products.count
  }
}

extension ShopListViewController: ProductDelegate {
  func createProduct(_ product: Product) {
    products.append(product)
    CoreDataHelper.shared.saveContext()

    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }

  func editProduct(at indexPath: IndexPath) {
    DispatchQueue.main.async {
      self.tableView.beginUpdates()
      self.tableView.reloadRows(at: [indexPath], with: .fade)
      self.tableView.endUpdates()
    }
  }
}
