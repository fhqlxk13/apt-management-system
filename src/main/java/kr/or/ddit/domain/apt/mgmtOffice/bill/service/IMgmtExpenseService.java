package kr.or.ddit.domain.apt.mgmtOffice.bill.service;

import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.ExpenseVO;

import java.util.List;

public interface IMgmtExpenseService {

    public List<ExpenseVO> selectExpenseList(ExpenseVO expenseVO);

    public int selectExpenseTotalAmount(ExpenseVO expenseVO);

    public int insertExpense(ExpenseVO expenseVO);

    public int updateExpense(ExpenseVO expenseVO);

    public int deleteExpense(ExpenseVO expenseVO);

    public int selectExpenseDuplicateCount(ExpenseVO expenseVO);
}
