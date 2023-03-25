//
//  SettingsViewController.swift
//  ComprasUSA
//
//  Created by Gabriel Patane Todaro on 07/03/23.
//

import UIKit

class SettingsViewController: UIViewController {

  @IBOutlet private weak var dolarTextField: UITextField!
  @IBOutlet private weak var iofTextField: UITextField!
  @IBOutlet private weak var addStateButton: UIButton!
  @IBOutlet private weak var statesTableView: UITableView!

  private let stateCellId = "stateCellIdentifier"
  
  var statesMock: Array<String> = []
  var taxMock: Array<String> = []

  override func viewDidLoad() {
    super.viewDidLoad()

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resignKeyboard))
    view.addGestureRecognizer(tapGesture)

    dolarTextField.delegate = self
    iofTextField.delegate = self

    statesTableView.delegate = self
    statesTableView.dataSource = self
    statesTableView.register(StateCell.self, forCellReuseIdentifier: stateCellId)

    let action = UIAction { action in
      self.presentStateAlert(isEditing: false)
    }
    addStateButton.addAction(action, for: .touchUpInside)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    dolarTextField.text = (UserDefaults.standard.string(forKey: UserDefaultsKeys.dolar.rawValue))
    iofTextField.text = (UserDefaults.standard.string(forKey: UserDefaultsKeys.iof.rawValue))

  }

  // MARK: Private methods

  @objc
  private func resignKeyboard() {
    dolarTextField.resignFirstResponder()
    iofTextField.resignFirstResponder()
  }

  private func presentStateAlert(isEditing: Bool) {
    let alert = UIAlertController(title: "Adicionar Estado",
                                  message: "",
                                  preferredStyle: .alert)

    // State name
    alert.addTextField { field in
      field.placeholder = "Adicione o nome do estado"
    }

    // State tax
    alert.addTextField { field in
      field.placeholder = "Imposto do estado"
      field.keyboardType = .decimalPad
    }

    alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
    alert.addAction(UIAlertAction(title: isEditing ? "Editar" : "Adicionar", style: .default) { _ in
      guard let state = alert.textFields?[0].text, !state.isEmpty,
            let tax = alert.textFields?[1].text, !tax.isEmpty else { return }
      self.addState(with: state, and: tax)
    })

    present(alert, animated: true)
  }

  private func addState(with name: String, and tax: String) {
    print("add a state")
    statesMock.append(name)
    taxMock.append(tax)
    statesTableView.reloadData()
  }
}

extension SettingsViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField == dolarTextField, let newValue = textField.text {
      UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.dolar.rawValue)
    } else if textField == iofTextField, let newValue = textField.text {
      UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.iof.rawValue)
    }
  }
}

extension SettingsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    56
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("selected row at \(indexPath.row)")
  }

  func tableView(_ tableView: UITableView,
                 commit editingStyle: UITableViewCell.EditingStyle,
                 forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      statesMock.remove(at: indexPath.row)
      taxMock.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
}

extension SettingsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: stateCellId, for: indexPath) as? StateCell else {
      return UITableViewCell()
    }

    cell.setInfo(name: statesMock[indexPath.row], tax: taxMock[indexPath.row])

    return cell
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if statesMock.count == 0 {
      statesTableView.setEmptyMessage("Your shop list is empty.\nAdd a new item using the + button above.")
    } else {
      statesTableView.restore()
    }

    return statesMock.count
  }
}
