require 'rails_helper'

include Cards::CardsService
include Constants::Error
include Constants::Hands

RSpec.describe "CardsService" do
  describe "バリデーションエラー" do
      error_01 = Constants::Error::ERR_MSG_INVALID_STYLE
      error_02 = Constants::Error::ERR_MSG_INVALID_CARD
      error_03 = Constants::Error::ERR_MSG_DOUBLE_CARD

  it 'コンマで区切っている' do
    expect(Cards::CardsService.validates("H10,C10,D10,S2,D8")).to eq [error_01]
  end

  it '区切りがない' do
  expect(Cards::CardsService.validates("H10C10D10S2D8")).to eq [error_01]
  end

  it 'スートではないアルファベット' do
    expect(Cards::CardsService.validates("D10 C13 D1 Z2 D8")).to eq ["4"+ error_02 +"(Z2)"]
  end


  it 'カードが重複している' do
  expect(Cards::CardsService.validates("H12 C10 D10 C10 D8")).to eq [error_03]
  end

  it 'カードが4枚' do
    expect(Cards::CardsService.validates("H12 C10 D8 H3")).to eq [error_01]
  end

  it 'カードが6枚' do
    expect(Cards::CardsService.validates("H12 C10 D10 D8 C1 H3")).to eq [error_01]
  end

  it '全角入力している' do
  expect(Cards::CardsService.validates("Ｈ１０　Ｃ１２　Ｄ８　Ｄ９　Ｃ１２")).to eq [error_01]
  end

  it 'ひらがなが入っている' do
    expect(Cards::CardsService.validates("H12 C10 D10 D8 C1 Hさん")).to eq [error_01]
  end

  it '機種依存文字が入っている' do
    expect(Cards::CardsService.validates("H12 C10 D10 D8 C1 ♡3")).to eq [error_01]
  end

  it '記号が入っている' do
    expect(Cards::CardsService.validates("H12 C10 D10 D8 C1 H?")).to eq [error_01]
  end

  end

  describe "正常系" do
    it '正常系' do
      expect(Cards::CardsService.validates("H12 C10 D10 C1 H3")).to eq []
    end
  end

  describe 'ポーカの役判定をする' do

    it 'ワンペアと判定する' do
      number = Cards::CardsService.checkCards("H12 C10 D10 C1 H3")
      expect(Cards::CardsService.change(number)).to eq Constants::Hands::Result[1]
    end

    it 'ツーペアと判定する' do
      number = Cards::CardsService.checkCards("H12 C10 D10 C12 H3")
      expect(Cards::CardsService.change(number)).to eq Constants::Hands::Result[2]
    end

    it 'スリー・オブ・ア・カインドと判定する' do
      number = Cards::CardsService.checkCards("C10 D10 H10 D1 C8")
      expect(Cards::CardsService.change(number)).to eq Constants::Hands::Result[3]
    end

    it 'ストレートと判定する' do
      number = Cards::CardsService.checkCards("D6 S5 D4 H3 C2")
      expect(Cards::CardsService.change(number)).to eq Constants::Hands::Result[4]
    end

    it 'フラッシュと判定する' do
      number = Cards::CardsService.checkCards("S13 S12 S11 S9 S6")
      expect(Cards::CardsService.change(number)).to eq Constants::Hands::Result[5]
    end

    it 'フルハウスと判定する' do
      number = Cards::CardsService.checkCards("H9 C9 S9 H1 C1")
      expect(Cards::CardsService.change(number)).to eq Constants::Hands::Result[6]
    end

    it 'フォー・オブ・ア・カインドと判定する' do
      number = Cards::CardsService.checkCards("D5 D6 H6 S6 C6")
      expect(Cards::CardsService.change(number)).to eq Constants::Hands::Result[7]
    end

    it 'ストレートフラッシュと判定する' do
      number = Cards::CardsService.checkCards("H1 H13 H12 H11 H10")
      expect(Cards::CardsService.change(number)).to eq Constants::Hands::Result[8]
    end

    it 'ハイカードと判定する' do
      number = Cards::CardsService.checkCards("C1 D10 S9 C5 C4")
      expect(Cards::CardsService.change(number)).to eq Constants::Hands::Result[0]
    end

  end

end

