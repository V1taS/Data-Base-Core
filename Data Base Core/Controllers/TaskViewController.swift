//
//  ViewController.swift
//  Data Base Core
//
//  Created by Виталий Сосин on 30.06.2020.
//  Copyright © 2020 Vitalii Sosin. All rights reserved.
//

import UIKit

class TaskViewController: UITableViewController {
    
    private let cellID = "cell"
    private var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        StorageManager.shared.fetchData(tasks: &tasks)
        tableView.reloadData()
    }
    
    // MARK: - Настройки Navigation Bar
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navBarAppearance.backgroundColor = .systemGray4
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTask)
        )
        
        navigationController?.navigationBar.tintColor = .black
    }
    
    @objc private func addTask() {
        showAlert(with: "New Task", and: "What do you want to do?")
    }
    
    // MARK: - Метод Алерт для добавления
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            StorageManager.shared.save(task)
            StorageManager.shared.fetchData(tasks: &self.tasks)
            
            let indexPath = IndexPath(row: self.tasks.count - 1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField()
        
        present(alert, animated: true)
    }
    
    // MARK: - Метод Алерт для редактирования
    private func showAlertEdit(with title: String, and message: String, textField: String, indexPath: IndexPath) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            
            StorageManager.shared.deletData(indexPath)
            StorageManager.shared.save(task)
            StorageManager.shared.fetchData(tasks: &self.tasks)
//
//            let indexPath = IndexPath(row: self.tasks.count - 1, section: 0)
//            self.tableView.insertRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField() { textFieldAlert in
            textFieldAlert.text = textField
        }
        
        present(alert, animated: true)
    }
    
    // MARK: - Метод удаления
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            StorageManager.shared.deletData(indexPath)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
    
    // MARK: - Метод перемещения ячейки
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let task = tasks.remove(at: sourceIndexPath.row)
        StorageManager.shared.deletData(sourceIndexPath)
        
        tasks.insert(task, at: destinationIndexPath.row)
        //        StorageManager.shared.insertData(destinationIndexPath)
        tableView.reloadData()
    }
    
    // MARK: - Метод редактирования данных
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let task = tasks[indexPath.row]
        showAlertEdit(with: "Редактирование", and: "👇", textField: task.name ?? "", indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - Table view data source
extension TaskViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.name
        return cell
    }
}
