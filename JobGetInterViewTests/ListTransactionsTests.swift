//
//  JobGetInterViewTests.swift
//  JobGetInterViewTests
//
//  Created by Mittal  gajjar on 2022-05-05.
//

import XCTest
@testable import JobGetInterView

extension ListTransactionViewModel {
    func addDummyData() {
        let transaction1 = Transaction()
        transaction1.id = 1
        transaction1.transactionType = TransactionType.expense.rawValue
        transaction1.transactionAmount = 12
        transaction1.transactionDescription = "D1"
        transaction1.dateTimeStamp = 1652121445
        self.transactions.append(transaction1)
        
        let transaction2 = Transaction()
        transaction2.id = 2
        transaction2.transactionType = TransactionType.expense.rawValue
        transaction2.transactionAmount = 8
        transaction2.transactionDescription = "D2"
        transaction2.dateTimeStamp = 1652121445
        self.transactions.append(transaction2)
        
        let transaction3 = Transaction()
        transaction3.id = 3
        transaction3.transactionType = TransactionType.income.rawValue
        transaction3.transactionAmount = 100
        transaction3.transactionDescription = "D3"
        transaction3.dateTimeStamp = 1652035045
        self.transactions.append(transaction3)
    }
}

class ListTransactionsTests: XCTestCase {

    var viewModel = ListTransactionViewModel()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTotalExpenseAndIncome() {
        viewModel.addDummyData()
        viewModel.groupTransactions()
        XCTAssertTrue(viewModel.totalExpense == 20, "Total Expense should be 20")
        XCTAssertTrue(viewModel.totalIncome == 100, "Total Income should be 100")
        XCTAssertTrue(viewModel.expenseBarValue == 0.2, "Total ExpenseBarValue should be 0.2")
    }
    
    func testTableViewContent() {
        viewModel.addDummyData()
        viewModel.groupTransactions()
        XCTAssertTrue(viewModel.getNumberOfSection() == 2)
        XCTAssertTrue(viewModel.getNumberOfRows(sectionNumber: 0) == 3)
        XCTAssertTrue(viewModel.getNumberOfRows(sectionNumber: 1) == 2)
        
        XCTAssertTrue(viewModel.getTitle(indexPath: IndexPath(row: 1, section: 0)) == "D1")
        XCTAssertTrue(viewModel.getPrice(indexPath: IndexPath(row: 1, section: 0)) == "-$12.00")
        XCTAssertTrue(viewModel.getTitle(indexPath: IndexPath(row: 1, section: 1)) == "D3")
        XCTAssertTrue(viewModel.getPrice(indexPath: IndexPath(row: 1, section: 1)) == "$100.00")
        XCTAssertTrue(viewModel.canDeleteRow(at: IndexPath(row: 0, section: 0)) == false)
        XCTAssertTrue(viewModel.canDeleteRow(at: IndexPath(row: 1, section: 1)) == true)
    }

}
