//
//  ViewController.swift
//  ComprasUSA
//
//  Created by Gabriel Patane Todaro on 02/03/23.
//

import CoreData
import UIKit

class ShopListViewController: UIViewController {

  private let productCellId = "productCellIdentifier"

  @IBOutlet weak var shopTableView: UITableView!

  var products = [Product]()

  override func viewDidLoad() {
    super.viewDidLoad()

    shopTableView.dataSource = self
    shopTableView.delegate = self
    shopTableView.register(ProductCell.self, forCellReuseIdentifier: productCellId)

    let addItemButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
    navigationItem.setRightBarButton(addItemButton, animated: true)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    getShopList()
  }

  private func getShopList() {
    let productsFetch: NSFetchRequest<Product> = Product.fetchRequest()
    let sortByDate = NSSortDescriptor(key: #keyPath(Product.name), ascending: true)
    productsFetch.sortDescriptors = [sortByDate]

    do {
      let managedContext = AppDelegate.shared.coreDataStack.managedContext
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
    AppDelegate.shared.coreDataStack.managedContext.delete(products[indexPath.row])
    products.remove(at: indexPath.row)

    AppDelegate.shared.coreDataStack.saveContext()
  }
}

extension ShopListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

    cell.setInfo(with: products[indexPath.row])
    return cell
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if products.count == 0 {
      shopTableView.setEmptyMessage("Your shop list is empty.\nAdd a new item using the + button above.")
    } else {
      shopTableView.restore()
    }

    return products.count
  }
}

extension ShopListViewController: ProductDelegate {
  func createProduct(_ product: Product) {
    products.append(product)
    AppDelegate.shared.coreDataStack.saveContext()

    DispatchQueue.main.async {
      self.shopTableView.reloadData()
    }
  }

  func editProduct(at indexPath: IndexPath) {
    DispatchQueue.main.async {
      self.shopTableView.beginUpdates()
      self.shopTableView.reloadRows(at: [indexPath], with: .fade)
      self.shopTableView.endUpdates()
    }
  }
}
