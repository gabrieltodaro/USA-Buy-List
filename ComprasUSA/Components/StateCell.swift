//
//  StateCell.swift
//  ComprasUSA
//
//  Created by Gabriel Patane Todaro on 25/03/23.
//

import UIKit

class StateCell: UITableViewCell {
  private let nameLabel = UILabel()
  private let taxLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    customInit()
  }

  required init?(coder: NSCoder) {
    fatalError("Shouldn't be initialized here.")
  }

  private func customInit() {
    let stackView = UIStackView(arrangedSubviews: [nameLabel, taxLabel])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillProportionally
    addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
      stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
      stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
      stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
    ])

    nameLabel.textAlignment = .left
    nameLabel.font = .systemFont(ofSize: 20, weight: .semibold)

    taxLabel.textAlignment = .right
    taxLabel.textColor = .red
    taxLabel.font = .systemFont(ofSize: 17)

  }

  func setInfo(with state: State) {
    nameLabel.text = state.name
    taxLabel.text = "\(state.tax)"
  }
}
