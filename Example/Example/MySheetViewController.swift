//
//  MySheetViewController.swift
//  Example
//
//  Created by Tibor Bödecs on 2019. 01. 18..
//  Copyright © 2019. Tibor Bödecs. All rights reserved.
//

import Sheet

class MySheetViewController: SheetViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Stars")
        self.stackView.addArrangedSubview(imageView)

        let label = UILabel()
        label.text = "Example"
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        
        self.stackView.addArrangedSubview(label)

        let details = UILabel()
        details.text = """
        Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor.
        Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh.
        """
        details.textAlignment = .center
        details.font = UIFont.preferredFont(forTextStyle: .body)
        details.numberOfLines = 0
        
        self.stackView.addArrangedSubview(details)

        let button = UIButton()
        button.backgroundColor = .purple
        button.titleLabel?.textColor = .white
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        button.layer.cornerRadius = 8
        
        self.stackView.addArrangedSubview(button)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 128),
            button.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
}
