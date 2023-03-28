//
//  SettingsViewController.swift
//  ComprasUSA
//
//  Created by Gabriel Patane Todaro on 07/03/23.
//

import CoreData
import UIKit

class SettingsViewController: UIViewController {

  @IBOutlet private weak var dolarTextField: UITextField!
  @IBOutlet private weak var iofTextField: UITextField!
  @IBOutlet private weak var addStateButton: UIButton!
  @IBOutlet private weak var statesTableView: UITableView!

  private let stateCellId = "stateCellIdentifier"
  
  var states = [State]()

  override func viewDidLoad() {
    super.viewDidLoad()

    dolarTextField.delegate = self
    iofTextField.delegate = self

    statesTableView.delegate = self
    statesTableView.dataSource = self
    statesTableView.register(StateCell.self, forCellReuseIdentifier: stateCellId)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getStates()

    dolarTextField.text = (UserDefaults.standard.string(forKey: UserDefaultsKeys.dolar.rawValue))
    iofTextField.text = (UserDefaults.standard.string(forKey: UserDefaultsKeys.iof.rawValue))

    let action = UIAction { action in
      self.presentStateAlert(state: nil, indexPath: nil)
    }
    addStateButton.addAction(action, for: .touchUpInside)

  }

  // MARK: Private methods

  private func getStates() {
    let statesFetch: NSFetchRequest<State> = State.fetchRequest()
    let sortByDate = NSSortDescriptor(key: #keyPath(State.name), ascending: true)
    statesFetch.sortDescriptors = [sortByDate]

    do {
      let managedContext = AppDelegate.shared.coreDataStack.managedContext
      let results = try managedContext.fetch(statesFetch)
      states = results
    } catch let error as NSError {
      print("Fetch error: \(error) description: \(error.userInfo)")
    }
  }

  @objc
  private func resignKeyboard() {
    dolarTextField.resignFirstResponder()
    iofTextField.resignFirstResponder()
  }

  private func presentStateAlert(state: State?, indexPath: IndexPath?) {
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
        field.text = "\(state.tax)"
      }
    }

    alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
    alert.addAction(UIAlertAction(title: isEditing ? "Editar" : "Adicionar", style: .default) { _ in
      guard let name = alert.textFields?[0].text, !name.isEmpty,
            let taxString = alert.textFields?[1].text, !taxString.isEmpty,
            let tax = Double(taxString) else { return }

      if isEditing, let indexPath {
        self.editState(at: indexPath, name: name, tax: tax)
      } else {
        let state = State(context: AppDelegate.shared.coreDataStack.managedContext)
        state.uid = UUID()
        state.name = name
        state.tax = tax
        self.addState(with: state)
      }
    })

    present(alert, animated: true)
  }

  private func addState(with state: State) {
    states.append(state)
    AppDelegate.shared.coreDataStack.saveContext()

    DispatchQueue.main.async {
      self.statesTableView.reloadData()
    }
  }

  private func editState(at index: IndexPath, name: String, tax: Double) {
    states[index.row].name = name
    states[index.row].tax = tax
    AppDelegate.shared.coreDataStack.saveContext()

    DispatchQueue.main.async {
      self.statesTableView.beginUpdates()
      self.statesTableView.reloadRows(at: [index], with: .fade)
      self.statesTableView.endUpdates()
    }
  }

  private func deleteState(at index: Int) {
    AppDelegate.shared.coreDataStack.managedContext.delete(states[index])
    states.remove(at: index)

    AppDelegate.shared.coreDataStack.saveContext()
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
    presentStateAlert(state: states[indexPath.row], indexPath: indexPath)
  }

  func tableView(_ tableView: UITableView,
                 commit editingStyle: UITableViewCell.EditingStyle,
                 forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      deleteState(at: indexPath.row)
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

    cell.setInfo(with: states[indexPath.row])

    return cell
  }

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    if states.count == 0 {
      statesTableView.setEmptyMessage("The state list is empty.\nAdd a new state using the + button below.")
    } else {
      statesTableView.restore()
    }

    return states.count
  }
}
