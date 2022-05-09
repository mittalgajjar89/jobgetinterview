//
//  AddTransactionViewController.swift
//  JobGetInterView
//
//  Created by Mittal  gajjar on 2022-05-05.
//

import UIKit
import DropDown
protocol AddTransactionViewDelegate: NSObjectProtocol {
    func didAddTransaction()
}

class AddTransactionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var popUPContentView: UIView!
    @IBOutlet weak var addTransactionLabel: UILabel!
    @IBOutlet weak var transactionTypeDropdownTextFiled: UITextField!
    @IBOutlet weak var transactionTypeDescriptionTextField: UITextField!
    @IBOutlet weak var expenseTypeButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var dropDownAmountView: UIView!
    @IBOutlet weak var decrementAmountBtn: UIButton!
    @IBOutlet weak var incrementAmountBtn: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    @IBOutlet var dissmissButton: UIButton!
    weak var delegate: AddTransactionViewDelegate?
    
    var addTransactionViewModel = AddTransactionViewModel()
    
    // MARK: Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.popUpBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyBoardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyBoardNotification()
    }
    
    // MARK: IBActions
    @IBAction func didPressDecrementButton(_ sender: Any) {
        var amount = Float(amountTextField.text ?? "") ?? 0
        amount = max(amount, 1)
        amountTextField.text = "\(amount - 1)"
    }
    
    @IBAction func didPressIncrementButton(_ sender: Any) {
        let amount = Float(amountTextField.text ?? "") ?? 0
        amountTextField.text = "\(amount + 1)"
    }
    
    @IBAction func didPressTransactionTypeButton(_ sender: Any) {
        let dropDown = DropDown()

        dropDown.anchorView = transactionTypeDropdownTextFiled
        let expenseTypes = TransactionType.allCases.compactMap({ $0.getTitle() })
        dropDown.dataSource = expenseTypes
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.transactionTypeDropdownTextFiled.text = item
            self.addTransactionViewModel.setTransactionType(type: index)
        }
        dropDown.show()
    }
    
    @IBAction func didPressAddButton(_ sender: Any) {
        let transactionDescription = transactionTypeDescriptionTextField.text ?? ""
        let amount = Float(amountTextField.text ?? "") ?? 0
        
        guard addTransactionViewModel.getTransactionType() != nil else {
            showError(error: "Please select transaction type")
            return
        }
        guard !transactionDescription.isEmpty else {
            showError(error: "Please enter transaction description")
            return
        }
        guard amount != nil, amount > 0 else {
            showError(error: "Please enter transaction amount")
            return
        }
        
        if addTransactionViewModel.addTransaction(amount: amount, description: transactionDescription) {
            self.delegate?.didAddTransaction()
            self.dismiss(animated: true)
        } else {
           
        }
    }
    
    @IBAction func didPressDissmissButton() {
        self.dismiss(animated: true)
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == amountTextField, string.count > 0 {
            let allowedCharacters = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "."]
            if string == "." && (textField.text ?? "").contains(".") {
                return false
            }
            return allowedCharacters.contains(string)
        }
        return true
    }
    
    func registerKeyBoardNotification() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] (notification) in
            guard let self = self else {
                return
            }
            
            let animationDuration =
                notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? CGFloat ?? 0.0
            self.centerYConstraint.constant = -100
            UIView.animate(withDuration: TimeInterval(animationDuration)) {
                self.view.layoutIfNeeded()
            }
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] (notification) in
            guard let self = self else {
                return
            }
            
            let animationDuration =
            notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? CGFloat ?? 0.0
            self.centerYConstraint.constant = 0
            UIView.animate(withDuration: TimeInterval(animationDuration)) {
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    func removeKeyBoardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func showError(error: String) {
        let alertController = UIAlertController(title: "Error!", message: error, preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}
