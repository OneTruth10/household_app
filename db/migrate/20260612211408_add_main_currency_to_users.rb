class AddMainCurrencyToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :main_currency_id, :integer, default: 1

  end
end
