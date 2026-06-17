class HomeController < ApplicationController
  before_action :set_exchange_rates

  def index
    # ログインしている場合は、自動的に出費一覧にリダイレクトさせたい場合は以下を有効にしてください
    # redirect_to expenses_path if user_signed_in?
  end

  private

  def set_exchange_rates
    require 'open-uri'
    require 'json'
    usd_json = JSON.parse(URI.open("https://api.frankfurter.app/latest?from=USD&to=JPY").read)
    @rates = {
      usd: usd_json["rates"]["JPY"],
      gbp: JSON.parse(URI.open("https://api.frankfurter.app/latest?from=GBP&to=JPY").read)["rates"]["JPY"],
      eur: JSON.parse(URI.open("https://api.frankfurter.app/latest?from=EUR&to=JPY").read)["rates"]["JPY"]
    }
  rescue => e
    logger.error "為替レートの取得に失敗しました: #{e.message}"
    @rates = { usd: 155.0, eur: 166.0, gbp: 195.0 }
  end
end