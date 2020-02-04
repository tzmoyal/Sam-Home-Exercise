//
//  ArticleCell.swift
//  SamNewsTask
//
//  Created by tzahi moyal on 02/02/2020.
//  Copyright © 2020 TZAHIMOYAL. All rights reserved.
//

import UIKit

class ArticelCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var articelImage: UIImageView!
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)

  }

  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)

  }
}
