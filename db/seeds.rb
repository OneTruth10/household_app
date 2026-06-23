# db/seeds.rb の中身
Currency.find_or_create_by!(code: 'JPY') { |c| c.symbol = '¥' }
Currency.find_or_create_by!(code: 'USD') { |c| c.symbol = '$' }
Currency.find_or_create_by!(code: 'EUR') { |c| c.symbol = '€' }
Currency.find_or_create_by!(code: 'GBP') { |c| c.symbol = '£' }
