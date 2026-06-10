class CreateExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :expenses do |t|
      # この行に precision: 10, scale: 2 を手動で追加します
      t.decimal :amount, precision: 10, scale: 2
      t.string :description
      t.date :recorded_at
      t.references :user, null: false, foreign_key: true
      t.references :currency, null: false, foreign_key: true

      t.timestamps
    end
  end
end