require 'rails_helper'

include Cards::CardsService

RSpec.describe "CardsService" do
  describe "バリデーションエラー" do

  it 'コンマで区切っている' do
    expect(Cards::CardsService.validates("H10,C10,D10,S2,D8")).to eq "5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"
  end

  it '区切りがない' do
  expect(Cards::CardsService.validates("H10C10D10S2D8")).to eq "5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"
  end

  it 'スートではないアルファベット' do
    expect(Cards::CardsService.validates("D10 C13 D1 Z2 D8")).to eq "5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"
  end


  it 'カードが重複している' do
  expect(Cards::CardsService.validates("H12 C10 D10 C10 D8")).to eq "カードが重複しています。"
  end

  it 'カードが4枚' do
  end

  it 'カードが6枚' do
    expect(Cards::CardsService.validates("H12 C10 D10 D8 C1 H3")).to eq "5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"
  end

  end

  describe "正常系" do
    it '正常系' do
      expect(Cards::CardsService.validates("H12 C10 D10 C1 H3")).to eq ""
    end
  end

  describe 'ポーカの役判定をする' do

    it 'ワンペアと判定する' do
      number = Cards::CardsService.checkCards("H12 C10 D10 C1 H3")
      expect(Cards::CardsService.change(number)).to eq "ワンペア"
    end

    it 'ツーペアと判定する' do
      number = Cards::CardsService.checkCards("H12 C10 D10 C12 H3")
      expect(Cards::CardsService.change(number)).to eq "ツーペア"
    end

    it 'スリー・オブ・ア・カインドと判定する' do
      number = Cards::CardsService.checkCards("C10 D10 H10 D1 C8")
      expect(Cards::CardsService.change(number)).to eq "スリー・オブ・ア・カインド"
    end

    it 'ストレートと判定する' do
      number = Cards::CardsService.checkCards("D6 S5 D4 H3 C2")
      expect(Cards::CardsService.change(number)).to eq "ストレート"
    end

    it 'フラッシュと判定する' do
      number = Cards::CardsService.checkCards("S13 S12 S11 S9 S6")
      expect(Cards::CardsService.change(number)).to eq "フラッシュ"
    end

    it 'フルハウスと判定する' do
      number = Cards::CardsService.checkCards("H9 C9 S9 H1 C1")
      expect(Cards::CardsService.change(number)).to eq "フルハウス"
    end

    it 'フォー・オブ・ア・カインドと判定する' do
      number = Cards::CardsService.checkCards("D5 D6 H6 S6 C6")
      expect(Cards::CardsService.change(number)).to eq "フォー・オブ・ア・カインド"
    end

    it 'ストレートフラッシュと判定する' do
      number = Cards::CardsService.checkCards("H1 H13 H12 H11 H10")
      expect(Cards::CardsService.change(number)).to eq "ストレートフラッシュ"
    end

    it 'ハイカードと判定する' do
      number = Cards::CardsService.checkCards("C1 D10 S9 C5 C4")
      expect(Cards::CardsService.change(number)).to eq "ハイカード"
    end

  end



  end

