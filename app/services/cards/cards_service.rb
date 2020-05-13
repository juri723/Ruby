module Cards
    module CardsService
    module_function
    include Constants

   def validates(card)  #入力された値が正しいかチェックする
    card = card.strip #空白の削除
    re = /^(((.|..|...)( )){4}(.|..|...))$/m
    re2 = /^(([CDHS])(1[0-3]|[1-9]))$/m

    return Constants::Error::ERR_MSG_Blank if card.blank?

    #● ● ● ● ●（半角スペースで区切られている）ことの確認。
    return Constants::Error::ERR_MSG_INVALID_STYLE if card.scan(re)  ==[]

    i = 1
    #それぞれのカードが適切なスート（C,D,H,S）と数字（1~13）になっているか。
    card.split.each do |p|
      return i.to_s + Constants::Error::ERR_MSG_INVALID_CARD + "("+ p + ")"  if p.scan(re2) == []
      i = i + 1
    end

    #カードの重複チェック
    return Constants::Error::ERR_MSG_DOUBLE_CARD if (!(card.split.uniq.count == 5) && card.split.length == 5)
   end

    def check_cards(card)  #入力したカードの値を引数とし、ポーカーの役判定を行う。
      numbers = card.delete("CDHS").split.map!(&:to_i).sort.group_by(&:itself).transform_values(&:size).values.sort #それぞれの数字のカードの枚数の配列を作成（昇順）
      num = card.delete("CDHS").split.map!(&:to_i).sort #文字列→数字、ソートをかける。
      gap = []

      #カードの差分を配列に代入する
      for i in 0..3 do
        gap[i] = num[i+1] - num[i]
      end

      #ストレートフラッシュ
      return 8 if ((gap == [1,1,1,1]) || (gap == [9,1,1,1]) || (gap == [1,1,1,9] ))  && (card.delete("0123456789").split.uniq.count == 1)

      #フォー・オブ・ア・カインド
      return 7 if numbers == [1,4]

      #フルハウス
      return 6 if (numbers == [2,3] || numbers == [3,2])

      #フラッシュ
      return 5 if card.delete("0123456789").split.uniq.count == 1

      #ストレート
      return 4 if (gap == [1,1,1,1]) || (gap == [9,1,1,1]) || (gap == [1,1,1,9] )

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
    def judge(cards)
      responses = {} #結果リストとエラーリストが格納されている。
      result_list = [] #結果リスト
      error_list = [] #エラーメッセージが入っている配列
      number_list = [] #結果番号が入っている配列
      i = 0
      n = 0

      cards.each do |card| #バリデーションが通らない場合、エラーリストを作成。通った場合は結果リストを作成。
        if  Cards::CardsService.validates(card).blank? then
          result_list[i] = {"card"=>card,"hand"=>"a","best"=>false}
          number_list[i] = Cards::CardsService.check_cards(card)
          result_list[i]["hand"] = Cards::CardsService.change(number_list[i])
          i = i + 1
        else
          error_list[n] = {"card"=>card,"msg"=>Cards::CardsService.validates(card)}
          n = n + 1
        end
      end

      #最も強い役にtrueを代入
      (result_list[number_list.find_index(number_list.max)]["best"] = true) unless number_list == []

      responses.store("result",result_list) if result_list.present?
      responses.store("error",error_list) if error_list.present?
      responses
    end

  end
  end