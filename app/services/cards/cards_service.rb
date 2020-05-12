module Cards
    module CardsService
    module_function
    include Constants::Error
    include Constants::Hands
    #入力された値が正しいかチェックする
   def validates(card)
    msg = []
    card = card.strip #空白の削除

    re = /^(((.|..|...)( )){4}(.|..|...))$/m
    re2 = /^(([CDHS])(1[0-3]|[1-9]))$/m

    #● ● ● ● ●（半角スペースで区切られている）ことの確認。
    if card.blank? || card.scan(re)  ==[] then
      msg.push(Constants::Error::ERR_MSG_INVALID_STYLE)
    end


    sgcard = card.split #カードの値を配列sgcard（シングルカード）に代入する。
    i = 1

    #それぞれのカードが適切なスート（C,D,H,S）と数字（1~13）になっているか。
    if msg.empty? then
    sgcard.each do |p|
      if p.scan(re2) == [] then
        msg.push(i.to_s + Constants::Error::ERR_MSG_INVALID_CARD + "("+ p + ")")
      end
      i = i + 1
    end
    end

    #カードの重複チェック
     if !(sgcard.uniq.count == 5) && sgcard.length == 5 then
      msg.push(Constants::Error::ERR_MSG_DOUBLE_CARD)
     end

      return msg

   end

    #入力したカードの値を引数とし、ポーカーの役判定を行う。
    def checkCards(card)
    suit = card.delete("0123456789").split #スートだけ取り出す(例：S)
    numbers = card.delete("CDHS").split.map!(&:to_i).sort.group_by(&:itself).transform_values(&:size).values.sort #それぞれの数字のカードの枚数の配列を作成（昇順）
    straight_flag = 01 #02だとストレートではない
    flush_flag = 01 #02だとフラッシュ
    num = card.delete("CDHS").split.map!(&:to_i).sort #文字列→数字、ソートをかける。
    gap = []
    result_number = 0

    for i in 0..3 do
      gap[i] = num[i+1] - num[i]
    end


    #ストレートのフラグ判定
      if (gap == [1,1,1,1]) || (gap == [9,1,1,1]) || (gap == [1,1,1,9] ) then
        straight_flag = 02
      end

      #フラッシュのフラグ判定
      if suit.uniq.count == 1 then
        flush_flag = 02
      end

      #ワンペア
      if numbers == [1,1,1,2] then
        result_number = 1
      end

      #ツーペア
      if numbers == [1,2,2] then
        result_number = 2
      end

      #スリー・オブ・ア・カインド
      if numbers == [1,1,3] then
        result_number = 3
      end

      #ストレート
      if straight_flag == 02 then
        result_number = 4
      end

      #フラッシュ
      if flush_flag == 02 then
        result_number = 5
      end

      #フルハウス
      if numbers == [2,3] || numbers == [3,2] then
        result_number = 6
      end

      #フォー・オブ・ア・カインド
      if numbers == [1,4] then
        result_number = 7
      end

      #ストレートフラッシュ
      if straight_flag == 02 && flush_flag == 02 then
        result_number = 8
      end

     return result_number

    end

    #結果番号を役名に変換する
    def change(number)
      result = Constants::Hands::Result
      return result[number]
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
          result_list[i] = {"card"=>"a","hand"=>"a","best"=>"a"}
          result_list[i]["card"] = card
          number_list[i] =Cards::CardsService.checkCards(card)
          result_list[i]["hand"] = Cards::CardsService.change(number_list[i])
          result_list[i]["best"] = false
          i = i + 1
        else
          error_list[n] = {"card"=>"","msg"=>""}
          error_list[n]["card"] += card
          error_list[n]["msg"] += Cards::CardsService.validates(card)[0]
          n = n + 1
        end
      end

      #役が最も強いインデックスを探し、変数xに代入
      unless number_list == [] then
      x = number_list.find_index(number_list.max)

      #最も強い役にtrueを代入
      result_list[x]["best"] = true

      end

      if result_list.present? then
        responses.store("result",result_list)
      end

      if error_list.present? then
        responses.store("error",error_list)
      end

      responses

    end

  end
  end