//
//  SettingsViewController.swift
//  ComprasUSA
//
//  Created by Gabriel Patane Todaro on 07/03/23.
//

import UIKit

struct State {
  let name, tax: String
}

class SettingsViewController: UIViewController {

  @IBOutlet private weak var dolarTextField: UITextField!
  @IBOutlet private weak var iofTextField: UITextField!
  @IBOutlet private weak var addStateButton: UIButton!
  @IBOutlet private weak var statesTableView: UITableView!

  private let stateCellId = "stateCellIdentifier"
  
  var statesMock: Array<State> = []

  override func viewDidLoad() {
    super.viewDidLoad()

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resignKeyboard))
    //    view.addGestureRecognizer(tapGesture)

    dolarTextField.delegate = self
    iofTextField.delegate = self

    statesTableView.delegate = self
    statesTableView.dataSource = self
    statesTableView.register(StateCell.self, forCellReuseIdentifier: stateCellId)

    let action = UIAction { action in
      self.presentStateAlert(state: nil, index: nil)
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

  private func presentStateAlert(state: State?, index: Int?) {
    let isEditing = state != nil
    let alertTitle = isEditing ? "Editar Estado" : "Adicionar Estado"
    let alert = UIAlertController(title: alertTitle,
                                  message: "Por favor, insira as informações sobre o estado.",
                                  preferredStyle: .alert)

    // State name
    alert.addTextField { field in
      field.placeholder = "Adicione o nome do estado"
      if let state {
        field.text = state.name
      }
    }

    // State tax
    alert.addTextField { field in
      field.placeholder = "Imposto do estado"
      field.keyboardType = .decimalPad
      if let state {
        field.text = state.tax
      }
    }

    alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
    alert.addAction(UIAlertAction(title: isEditing ? "Editar" : "Adicionar", style: .default) { _ in
      guard let name = alert.textFields?[0].text, !name.isEmpty,
            let tax = alert.textFields?[1].text, !tax.isEmpty else { return }

      let state = State(name: name, tax: tax)
      self.addState(with: state)

      // Editing is not working yet
//      if isEditing, let index {
//        self.editState(at: index, state: state)
//      } else {
//        self.addState(with: state)
//      }
    })

    present(alert, animated: true)
  }

  private func addState(with state: State) {
    print("add a state")
    statesMock.append(state)
    statesTableView.reloadData()
  }

  private func editState(at index: Int, state: State) {

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
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    56
  }

  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    presentStateAlert(state: statesMock[indexPath.row], index: indexPath.row)
  }

  func tableView(_ tableView: UITableView,
                 commit editingStyle: UITableViewCell.EditingStyle,
                 forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      statesMock.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
}

extension SettingsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: stateCellId, for: indexPath) as? StateCell else {
      return UITableViewCell()
    }

    cell.setInfo(with: statesMock[indexPath.row])

    return cell
  }

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    if statesMock.count == 0 {
      statesTableView.setEmptyMessage("The state list is empty.\nAdd a new state using the + button below.")
    } else {
      statesTableView.restore()
    }

    return statesMock.count
  }
}
