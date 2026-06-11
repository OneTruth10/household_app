# 既存のデータを一度削除して綺麗にする（重複登録を防ぐため）
Currency.destroy_all

# 通貨のマスターデータを作成
Currency.create!(code: 'JPY', symbol: '¥')
Currency.create!(code: 'USD', symbol: '$')
Currency.create!(code: 'EUR', symbol: '€')
Currency.create!(code: 'GBP', symbol: '£')

puts "通貨データの作成が完了しました！ (JPY, USD, EUR, GBP)"

