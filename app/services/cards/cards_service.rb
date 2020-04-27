
  module Cards
    module CardsService
    module_function

    #入力された値が正しいかチェックする
   def validates(card)
    sgcard = card.split #カード（例：S10)
    msg = "" #バリデーション結果

    re = /(([CDHS])(1[0-3]|[1-9])( )){4}(([CDHS])(1[0-3]|[1-9]))/m

    if card.scan(re)  ==[] then
      msg = "5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"
    end

    unless sgcard.length == 5 then
      msg = msg + "カードが4枚以下か6枚以上です。"
    end

    if !(sgcard.uniq.count == 5) && sgcard.length == 5 then #カードの重複チェック
      msg = msg + "カードが重複しています。"
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
      if gap == ( [1,1,1,1] || [1,1,1,9] ) then
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

    #結果番号を役目に反映する
    def change(number)
      result = %w(ハイカード ワンペア ツーペア スリー・オブ・ア・カインド ストレート フラッシュ フルハウス フォー・オブ・ア・カインド ストレートフラッシュ)
      return result[number]
    end

    #カードリストを受け取り、結果リストの返却
    def judge(cards)
      responses = {}
      result_list = []
      error_list = []
      rnumber_list=[]
      i = 0
      n = 0

      cards.each do |card| #バリデーションが通らない場合、エラーリストを作成。通った場合は結果リストを作成。
        if  Cards::CardsService.validates(card).blank? then
          result_list[i] = {"card"=>[],"hand"=>[],"best"=>[]}
          result_list[i]["card"].push(card)
          number = Cards::CardsService.checkCards(card)
          rnumber_list[i] = number
          result_list[i]["hand"].push(Cards::CardsService.change(number))
          result_list[i]["best"] = false
          i = i + 1
        else
          error_list[n] = {"card"=>[],"msg"=>[]}
          error_list[n]["card"].push(card)
          error_list[n]["msg"].push(Cards::CardsService.validates(card))
          n = n + 1
        end
      end

      #役が最も強いインデックスを探し、変数xに代入
      x = rnumber_list.find_index(rnumber_list.max)

      #最も強い役にtrueを代入
      result_list[x]["best"] = true

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