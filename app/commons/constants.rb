module Constants
  module Error
    ERR_MSG_BLANK = "値を入力してください。"
    ERR_MSG_INVALID_STYLE ="5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"
    ERR_MSG_INVALID_CARD = "番目のカード指定文字が不正です。"
    ERR_MSG_DOUBLE_CARD = "カードが重複しています。"
  end
  module Hands
    Result =["ハイカード","ワンペア","ツーペア","スリー・オブ・ア・カインド","ストレート","フラッシュ","フルハウス","フォー・オブ・ア・カインド","ストレートフラッシュ"]
  end

end