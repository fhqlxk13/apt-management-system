package kr.or.ddit.domain.apt.mgmtOffice.bill.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.ExpenseVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IMgmtExpenseMapper {

    List<ExpenseVO> selectExpenseList(ExpenseVO expenseVO);

    int selectExpenseTotalAmount(ExpenseVO expenseVO);

    int insertExpense(ExpenseVO expenseVO);

    int updateExpense(ExpenseVO expenseVO);

    int deleteExpense(ExpenseVO expenseVO);

    int selectExpenseDuplicateCount(ExpenseVO expenseVO);
}
