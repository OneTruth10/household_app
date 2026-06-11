class ExpensesController < ApplicationController
  # ログインしていないユーザーは強制的にログイン画面へリダイレクトする
  before_action :authenticate_user!

  # list of spendings
  def index
    # Select month from params or use default current month
    @selected_month = params[:month].presence || Time.zone.today.strftime("%Y-%m")

    # 2. Take start date as the first date of the month then end date of month
    start_date = Date.parse("#{@selected_month}-01")
    end_date = start_date.end_of_month

    # 3. 指定された期間内の出費データだけを、ログインユーザーから取得
    @expenses = current_user.expenses
                            .where(recorded_at: start_date..end_date)
                            .order(recorded_at: :desc)

    @totals_by_currency = @expenses.group(:currency_id).sum(:amount)
  end

  # 出費入力画面
  def new
    # 画面のフォームに渡すための、空の出費オブジェクトを作る
    @expense = current_user.expenses.build
  end

  # 出費をデータベースに保存する処理
  def create
    @expense = current_user.expenses.build(expense_params)
    
    if @expense.save
      redirect_to expenses_path, notice: '出費を記録しました！'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # 画面から送られてきたデータのうち、許可するカラムを指定（セキュリティ対策）
  def expense_params
    params.require(:expense).permit(:amount, :description, :recorded_at, :currency_id)
  end
end