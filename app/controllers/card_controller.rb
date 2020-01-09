class CardController < ApplicationController


  require "payjp"

  def new
    card = Card.where(user_id: 1) #1をcurrent_user.idとしたい
    redirect_to action: "show" if card.exists?
  end
  def pay #payjpとCardのデータベース作成を実施します。
    Payjp.api_key = Rails.application.credentials.dig(:payjp, :payjp_test_secret_access_key) #creddential.yml.enb から呼び出せないので仮置き
    if params['payjp-token'].blank?
      redirect_to action: "new"
    else
      customer = Payjp::Customer.create(
      description: '登録テスト', #なくてもOK
      # email: current_user.email, #なくてもOK
      card: params['payjp-token'],
      # metadata: {user_id: current_user.id}
      metadata: {user_id: 1}
      ) #念の為metadataにuser_idを入れましたがなくてもOK
      # @card = Card.new(user_id: current_user.id, customer_id: customer.id, card_id: customer.default_card)
      @card = Card.new(user_id: 1, customer_id: customer.id, card_id: customer.default_card)
      
      if @card.save
        redirect_to action: "show"
      else
        redirect_to action: "pay"
      end
    end
  end
end
