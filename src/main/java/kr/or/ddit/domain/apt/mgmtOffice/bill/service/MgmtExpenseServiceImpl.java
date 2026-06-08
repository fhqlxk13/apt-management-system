package kr.or.ddit.domain.apt.mgmtOffice.bill.service;

import kr.or.ddit.domain.apt.mgmtOffice.bill.mapper.IMgmtExpenseMapper;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.ExpenseVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class MgmtExpenseServiceImpl implements IMgmtExpenseService{

    @Autowired
    private IMgmtExpenseMapper expenseMapper;

    @Override
    public List<ExpenseVO> selectExpenseList(ExpenseVO expenseVO) {
        return expenseMapper.selectExpenseList(expenseVO);
    }

    @Override
    public int selectExpenseTotalAmount(ExpenseVO expenseVO) {
        return expenseMapper.selectExpenseTotalAmount(expenseVO);
    }

    @Transactional
    @Override
    public int insertExpense(ExpenseVO expenseVO) {
        return expenseMapper.insertExpense(expenseVO);
    }

    @Transactional
    @Override
    public int updateExpense(ExpenseVO expenseVO) {
        return expenseMapper.updateExpense(expenseVO);
    }

    @Transactional
    @Override
    public int deleteExpense(ExpenseVO expenseVO) {
        return expenseMapper.deleteExpense(expenseVO);
    }

    @Override
    public int selectExpenseDuplicateCount(ExpenseVO expenseVO) {
        return expenseMapper.selectExpenseDuplicateCount(expenseVO);
    }
}
