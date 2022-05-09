//
//  ViewController.swift
//  JobGetInterView
//
//  Created by Mittal  gajjar on 2022-05-05.
//

import UIKit

class ListTransactionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, AddTransactionViewDelegate {
    
    @IBOutlet var priceSummaryView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var incomeView: ExpensesView!
    @IBOutlet weak var expenseView: ExpensesView!
    @IBOutlet weak var balanceView: ExpensesView!
    @IBOutlet weak var progressBarView: ProgressBarView!
    
    var listViewModel = ListTransactionViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        designView()
        fetchData()
        tableView.register(ListExpensesTableViewCell.self)
    }

    func fetchData() {
        DispatchQueue.global().async {
            self.listViewModel.fetchData()
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.incomeView.price = self.listViewModel.totalIncome
                self.expenseView.price = self.listViewModel.totalExpense
                self.balanceView.price = self.listViewModel.totalIncome - self.listViewModel.totalExpense
                self.progressBarView.progress = self.listViewModel.expenseBarValue
            }
        }
    }
    func designView() {
        priceSummaryView.layer.borderColor = UIColor.darkGray.cgColor
        priceSummaryView.layer.borderWidth = 1
        priceSummaryView.layer.cornerRadius = 5
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.getNumberOfRows(sectionNumber: section)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return listViewModel.getNumberOfSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ListExpensesTableViewCell.self, indexPath: indexPath)
        cell.title = listViewModel.getTitle(indexPath: indexPath)
        cell.price = listViewModel.getPrice(indexPath: indexPath)
        
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard listViewModel.canDeleteRow(at: indexPath) else {
            return nil
        }
        let item = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            self.listViewModel.deleteRow(at: indexPath)
            self.fetchData()
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [item])
        return swipeActions
    }
    func didAddTransaction() {
        self.fetchData()
    }
    
    @IBAction func didPressAddButton() {
        let storyBoard  = UIStoryboard(name: "Main", bundle: nil)
        let addTransactionController = storyBoard.instantiateViewController(withIdentifier: "AddTransactionViewController") as! AddTransactionViewController
        addTransactionController.modalPresentationStyle = .overCurrentContext
        addTransactionController.modalTransitionStyle = .crossDissolve
        addTransactionController.delegate = self
        present(addTransactionController, animated: true, completion: nil)
    }
    
}

