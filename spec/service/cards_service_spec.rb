require 'rails_helper'

RSpec.describe "CardsService" do
  describe "バリデーションエラー" do

    it '値が入力されてない' do
        expect(Cards::CardsService.validates("")).to eq ["値を入力してください。"]
    end

  it 'コンマで区切っている' do
    expect(Cards::CardsService.validates("H10,C10,D10,S2,D8")).to eq ["5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"]
  end

  it '区切りがない' do
  expect(Cards::CardsService.validates("H10C10D10S2D8")).to eq ["5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"]
  end

  it 'スートではないアルファベット' do
    expect(Cards::CardsService.validates("D10 C13 D1 Z2 D8")).to eq ["4番目のカード指定文字が不正です。(Z2)"]
  end


  it 'カードが重複している' do
  expect(Cards::CardsService.validates("H12 C10 D10 C10 D8")).to eq ["カードが重複しています"]
  end

  it 'カードが4枚' do
    expect(Cards::CardsService.validates("H12 C10 D8 H3")).to eq ["5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"]
  end

  it 'カードが6枚' do
    expect(Cards::CardsService.validates("H12 C10 D10 D8 C1 H3")).to eq ["5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"]
  end

  it '全角入力している' do
  expect(Cards::CardsService.validates("Ｈ１０　Ｃ１２　Ｄ８　Ｄ９　Ｃ１２")).to eq ["5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"]
  end

  it 'ひらがなが入っている' do
    expect(Cards::CardsService.validates("H12 C10 D10 D8 C1 Hさん")).to eq ["5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"]
  end

  it '機種依存文字が入っている' do
    expect(Cards::CardsService.validates("H12 C10 D10 D8 C1 ♡3")).to eq ["5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"]
  end

  it '記号が入っている' do
    expect(Cards::CardsService.validates("H12 C10 D10 D8 C1 H?")).to eq ["5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"]
  end

  end

  describe "正常系" do
    it '正常系' do
      expect(Cards::CardsService.validates("H12 C10 D10 C1 H3")).to eq nil
    end
  end

  describe 'ポーカの役判定をする' do

    it 'ワンペアと判定する' do
      number = Cards::CardsService.check_cards("H12 C10 D10 C1 H3")
      expect(Cards::CardsService.change(number)).to eq "ワンペア"
    end

    it 'ツーペアと判定する' do
      number = Cards::CardsService.check_cards("H12 C10 D10 C12 H3")
      expect(Cards::CardsService.change(number)).to eq "ツーペア"
    end

    it 'スリー・オブ・ア・カインドと判定する' do
      number = Cards::CardsService.check_cards("C10 D10 H10 D1 C8")
      expect(Cards::CardsService.change(number)).to eq "スリー・オブ・ア・カインド"
    end

    it 'ストレートと判定する' do
      number = Cards::CardsService.check_cards("D6 S5 D4 H3 C2")
      expect(Cards::CardsService.change(number)).to eq "ストレート"
    end

    it 'フラッシュと判定する' do
      number = Cards::CardsService.check_cards("S13 S12 S11 S9 S6")
      expect(Cards::CardsService.change(number)).to eq "フラッシュ"
    end

    it 'フルハウスと判定する' do
      number = Cards::CardsService.check_cards("H9 C9 S9 H1 C1")
      expect(Cards::CardsService.change(number)).to eq "フルハウス"
    end

    it 'フォー・オブ・ア・カインドと判定する' do
      number = Cards::CardsService.check_cards("D5 D6 H6 S6 C6")
      expect(Cards::CardsService.change(number)).to eq "フォー・オブ・ア・カインド"
    end

    it 'ストレートフラッシュと判定する' do
      number = Cards::CardsService.check_cards("H1 H13 H12 H11 H10")
      expect(Cards::CardsService.change(number)).to eq "ストレートフラッシュ"
    end

    it 'ハイカードと判定する' do
      number = Cards::CardsService.check_cards("C1 D10 S9 C5 C4")
      expect(Cards::CardsService.change(number)).to eq "ハイカード"
    end

  end

end

