module Cards
    module CardsService
    module_function
    include Constants

   def validates(card)  #入力された値が正しいかチェックする
    card = card.strip #空白の削除
    re = /^((.{1,3}( )){4}(.{1,3}))$/m
    re2 = /^(([CDHS])(1[0-3]|[1-9]))$/m
    msg = []

    msg << Constants::Error::ERR_MSG_BLANK and return msg if card.blank?

    #● ● ● ● ●（半角スペースで区切られている）ことの確認。
    msg << Constants::Error::ERR_MSG_INVALID_STYLE and return msg if card.scan(re)  ==[]

    #それぞれのカードが適切なスート（C,D,H,S）と数字（1~13）になっているか。
    card.split.each_with_index do |p,index|
      msg << (index+1).to_s + Constants::Error::ERR_MSG_INVALID_CARD + "("+ p + ")"  if p.scan(re2) == []
      return msg if (index == card.split.size - 1) && msg.present?
    end

    #カードの重複チェック
    msg << Constants::Error::ERR_MSG_DOUBLE_CARD and return msg unless card.split.uniq.count == 5
   end

    def check_cards(card)  #入力したカードの値を引数とし、ポーカーの役判定を行う。
      num = card.delete("CDHS").split.map!(&:to_i).sort #文字列→数字、ソートをかける。
      numbers = num.sort.group_by(&:itself).transform_values(&:size).values.sort #それぞれの数字のカードの枚数の配列を作成（昇順）
      gap = []

      #カードの差分を配列に代入する
      for i in 0..3 do
        gap[i] = num[i+1] - num[i]
      end

      #ストレートフラッシュ
      return 8 if straight?(gap)  && flash?(card)

      #フォー・オブ・ア・カインド
      return 7 if numbers == [1,4]

      #フルハウス
      return 6 if (numbers == [2, 3] || numbers == [3,2])

      #フラッシュ
      return 5 if flash?(card)

      #ストレート
      return 4 if straight?(gap)

      #スリー・オブ・ア・カインド
      return 3 if numbers == [1,1,3]

      #ツーペア
      return 2 if numbers == [1,2,2]

      #ワンペア
      return 1 if numbers == [1,1,1,2]

      #ハイカード
      return 0

    end

    #結果番号を役名に変換する
    def change(number)
      return Constants::Hands::Result[number]
    end

    #カードリストを受け取り、結果の返却
    def result(cards)
      responses = {} #結果リストとエラーリストが格納されている。
      results_list = [] #結果リスト
      error_list = [] #エラーリスト

      cards.each do |card| #バリデーションが通らない場合、エラーリストを作成。通った場合は結果リストを作成。
        if  Cards::CardsService.validates(card).blank? then
          result_number = Cards::CardsService.check_cards(card)
          results_list << {card:card, hand:Cards::CardsService.change(result_number), best:false, score:result_number}
        else
          error_list << {card:card, msg:Cards::CardsService.validates(card)}
        end
      end

      #最も強い役にtrueを代入
      best_hands = results_list.max_by{ |result| result[:score]}

      best_hands[:best] = true if best_hands.present?
      results_list.each do |result|
        result.delete(:score)
      end

      responses.store("result",results_list) if results_list.present?
      responses.store("error",error_list) if error_list.present?
      responses
    end

    def straight?(gap)
      (gap == [1,1,1,1]) || (gap == [9,1,1,1]) || (gap == [1,1,1,9])
    end

    def flash?(card)
      card.delete("0123456789").split.uniq.count == 1
    end

  end
  end