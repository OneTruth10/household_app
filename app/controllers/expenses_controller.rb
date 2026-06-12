class ExpensesController < ApplicationController
  # ログインしていないユーザーは強制的にログイン画面へリダイレクトする
  before_action :authenticate_user!
  before_action :set_exchange_rates
  before_action :set_expense, only: [:edit, :destroy, :update]

  # list of spendings
  def index
    # Select month from params or use default current month
    @selected_month = params[:month].presence || Time.zone.today.strftime("%Y-%m")

    # 2. Take start date as the first date of the month then end date of month
    start_date = Date.parse("#{@selected_month}-01")
    end_date = start_date.end_of_month

    # 3. 指定された期間内の出費データだけを、ログインユーザーから取得（一覧表示用：並び替えあり）
    @expenses = current_user.expenses
                            .where(recorded_at: start_date..end_date)
                            .order(recorded_at: :desc)

    rate_table = {
      "USD" => @rates[:usd],
      "JPY" => 1,
      "GBP" => @rates[:gbp],
      "EUR" => @rates[:eur]
    }

    # Need to explicitly mention onder of date is not considered
    @totals_by_currency = @expenses.unscope(:order).group(:currency_id).sum(:amount)

    @total_jpy = 0
    @totals_by_currency.each do |currency_id, amount|
      currency_code = Currency.find(currency_id).code
      @total_jpy += rate_table[currency_code] * amount
    end
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

  def edit
  end

  def destroy
    @expense.destroy
    redirect_to expenses_path, notice: "Deleted expense", status: :see_other
  end

  def update
    if @expense.update(expense_params)
      redirect_to expenses_path, notice: "Successfully updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end


  private

  # 画面から送られてきたデータのうち、許可するカラムを指定（セキュリティ対策）
  def expense_params
    params.require(:expense).permit(:amount, :description, :recorded_at, :currency_id)
  end

  def set_expense
    @expense = current_user.expenses.find(params[:id])
  end

  def set_exchange_rates
    require 'open-uri'
    require 'json'

    usd_json = JSON.parse(URI.open("https://api.frankfurter.app/latest?from=USD&to=JPY").read)
    usd_jpy = usd_json["rates"]["JPY"]

    gbp_json = JSON.parse(URI.open("https://api.frankfurter.app/latest?from=GBP&to=JPY").read)
    gbp_jpy = gbp_json["rates"]["JPY"]

    eur_json = JSON.parse(URI.open("https://api.frankfurter.app/latest?from=EUR&to=JPY").read)
    eur_jpy = eur_json["rates"]["JPY"]
    # 各通貨の対USDレートをハッシュとしてまとめて保持する
    @rates = {
      usd: usd_jpy,
      gbp: gbp_jpy,
      eur: eur_jpy
    }
  rescue => e
    logger.error "為替レートの取得に失敗しました: #{e.message}"
    # APIが落ちていた場合の保険（固定レート）
    @rates = { usd: 155.0, eur: 166.0, gbp: 195.0 }
  end
end