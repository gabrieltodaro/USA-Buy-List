//
//  ProductCell.swift
//  ComprasUSA
//
//  Created by Gabriel Patane Todaro on 28/03/23.
//

import UIKit

class ProductCell: UITableViewCell {
  private let productImageView = UIImageView()
  private let nameLabel = UILabel()
  private let valueLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    customInit()
  }

  required init?(coder: NSCoder) {
    fatalError("Shouldn't be initialized here.")
  }

  private func customInit() {
    productImageView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(productImageView)
    NSLayoutConstraint.activate([
      productImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
      productImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
      productImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
      productImageView.widthAnchor.constraint(equalToConstant: 64)
    ])
    productImageView.contentMode = .scaleAspectFit

    let stackView = UIStackView(arrangedSubviews: [nameLabel, valueLabel])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillProportionally
    addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.leftAnchor.constraint(equalTo: productImageView.rightAnchor, constant: 8),
      stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
      stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
      stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
    ])

    nameLabel.textAlignment = .left
    nameLabel.font = .systemFont(ofSize: 22, weight: .semibold)

    valueLabel.textAlignment = .right
    valueLabel.textColor = .gray
    valueLabel.font = .systemFont(ofSize: 18)

  }

  func setInfo(with product: Product) {
    productImageView.image = product.unloadedImage
    nameLabel.text = product.name
    valueLabel.text = "\(product.price)"
  }
}
