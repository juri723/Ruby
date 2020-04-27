class CardsController < ApplicationController

  include Cards::CardsService #ServiceをControllerでも利用できるようにする。

#カードの値が正しいかをチェックし、ポーカーの役判定を行う。
  def post
    @card = params[:cards] #入力されたカードの値を変数に代入
    @msg = Cards::CardsService.validates(@card) #バリデーション結果を変数に代入

    if @msg.blank? then
      number = Cards::CardsService.checkCards(@card)
      @result = Cards::CardsService.change(number)
    else

    end
    render :index
  end

end