//
//  ViewController.swift
//  vorobey-uikit-4
//
//  Created by Павел Бубликов on 11.03.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    enum Section: Hashable{
        case first
    }
    
    private var items: [TableCell] = []
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, TableCell> = {
        let dataSource = UITableViewDiffableDataSource<Section, TableCell>(tableView: tableView) { tableView, _, model in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell()
            }
            cell.textLabel?.text = model.title
            if model.isChecked {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        }
        return dataSource
    }()

    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "task 4"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "shuffle", style: .plain, target: self, action: #selector(shuffle))
        
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        view.backgroundColor = .systemGray6
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
        
        createItems()
        configureSnapshot()
    }
    
    @objc private func shuffle() {
        items.shuffle()
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.first])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func createItems() {
        for x in 1...50 {
            items.append(TableCell(title: String(x), isChecked: false))
        }
    }
    
    private func configureSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TableCell>()
        snapshot.appendSections([.first])
        snapshot.appendItems(items)
        dataSource.apply(snapshot)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let model = dataSource.itemIdentifier(for: indexPath),
            let firstItem = dataSource.itemIdentifier(for: IndexPath(row: 0, section: 0))
        else {
            return
        }
        
        model.isChecked = !model.isChecked
        var snapshot = dataSource.snapshot()
        var isAnimated = false
        
        snapshot.reloadItems([model])
        
        if model.isChecked, model != firstItem {
            snapshot.moveItem(model, beforeItem: firstItem)
            isAnimated = true
        }
        
        
        dataSource.apply(snapshot, animatingDifferences: isAnimated)
    }
}
