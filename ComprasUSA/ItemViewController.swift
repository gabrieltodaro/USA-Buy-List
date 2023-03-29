//
//  ItemViewController.swift
//  ComprasUSA
//
//  Created by Gabriel Patane Todaro on 07/03/23.
//

import CoreData
import UniformTypeIdentifiers
import UIKit

protocol ProductDelegate {
  func createProduct(_ product: Product)
  func editProduct(_ product: Product)
}

class ItemViewController: UIViewController {

  @IBOutlet weak var productNameTextField: UITextField!
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var statePickerView: UITextField!
  @IBOutlet weak var addStateButton: UIButton!
  @IBOutlet weak var valueInDolarTextField: UITextField!
  @IBOutlet weak var addIOFButton: UISwitch!
  @IBOutlet weak var addButton: UIButton!

  var delegate: ProductDelegate?
  var product: Product?

  private var states = [State]()

  override func viewDidLoad() {
    super.viewDidLoad()

    let resignKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(resignKeyboard))
    view.addGestureRecognizer(resignKeyboardGesture)

    let addImageGesture = UITapGestureRecognizer(target: self, action: #selector(addImage))
    productImageView.isUserInteractionEnabled = true
    productImageView.addGestureRecognizer(addImageGesture)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getStates()

    if product != nil {
      addButton.setTitle("EDITAR", for: .normal)
      addButton.setTitle("EDITAR", for: .disabled)
    } else {
      addButton.setTitle("CADASTRAR", for: .normal)
      addButton.setTitle("CADASTRAR", for: .disabled)
    }

    let pickerView = UIPickerView()
    pickerView.delegate = self
    pickerView.dataSource = self
    statePickerView.inputView = pickerView
  }

  // MARK: Actions
  @IBAction func saveProduct(_ sender: Any) {
    if let product {
      delegate?.editProduct(product)
    } else {
      //      delegate?.createProduct()
    }
  }

  @IBAction func addState(_ sender: Any) {
    let alert = UIAlertController(title: "Adicionar novo estado",
                                  message: "Para adicionar um novo estado, precisamos redirecionar para a página de ajustes. Deseja ser movido para esta tela?",
                                  preferredStyle: .alert)

    let moveAction = UIAlertAction(title: "Sim", style: .default) { _ in
      DispatchQueue.main.async {
        self.tabBarController?.selectedIndex = 1
      }
    }
    alert.addAction(moveAction)

    alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))

    present(alert, animated: true)
  }

  // MARK: - Private methods
  @objc
  private func resignKeyboard() {
    productNameTextField.resignFirstResponder()
    statePickerView.resignFirstResponder()
    valueInDolarTextField.resignFirstResponder()
  }

  @objc
  private func addImage() {
    let alert = UIAlertController(title: "Como você deseja adicionar uma foto?",
                                  message: "",
                                  preferredStyle: .actionSheet)

    let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { _ in
      self.openImagePicker(with: .photoLibrary)
    }
    alert.addAction(libraryAction)

    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      let cameraAction = UIAlertAction(title: "Câmera", style: .default) { _ in
        self.openImagePicker(with: .camera)
      }
      alert.addAction(cameraAction)
    }


    alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))

    present(alert, animated: true)
  }

  private func openImagePicker(with sourceType: UIImagePickerController.SourceType) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    imagePicker.sourceType = sourceType
    imagePicker.mediaTypes = [UTType.image.identifier]
    imagePicker.modalPresentationStyle = .popover

    self.present(imagePicker, animated: true)
  }

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
}

// MARK: - Image Picker Delegate
extension ItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    // Check for the media type
    let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! String
    switch mediaType {
      case UTType.image.identifier:
        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        // Get it to save on Product Entity
        let imageData = editedImage.pngData()
        productImageView.image = editedImage

      default:
        print("Mismatched type: \(mediaType)")
    }

    picker.dismiss(animated: true, completion: nil)
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true)
  }
}

// MARK: - Picker Delegate & Data Source
extension ItemViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    states.count
  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    1
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    states[row].name
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    // Get it to save on Product Entity
    let stateUid = states[row].uid
    statePickerView.text = states[row].name
  }
}
