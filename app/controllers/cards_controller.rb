class CardsController < ApplicationController

  include Cards::CardsService #ServiceをControllerでも利用できるようにする。

#カードの値が正しいかをチェックし、ポーカーの役判定を行う。
  def post

    @card = params[:cards]

    @msg = Cards::CardsService.validates(@card) #バリデーション結果を変数に代入する

    render :index and return @msg if @msg.present? #もしバリデーションが引っかかったら結果をviewに返却する

    @result = Cards::CardsService.change(Cards::CardsService.check_cards(@card)) #カードの役判定を行う
    render :index

  end

end