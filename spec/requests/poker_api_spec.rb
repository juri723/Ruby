require 'rails_helper'

RSpec.describe '/api/poker', type: :request do

  #正常系
  describe 'POST #post' do
    before{post '/api/poker', params: {cards:["H1 H13 H12 H11 C8","H10 C2 D3 D9 D10"]}}

    it 'has a 201 http status code' do
      expect(response).to have_http_status(:created)
    end

    it '結果リストが返ってくる' do
      json = JSON.parse(response.body)
      expect(json['result']).to eq([{card: "H1 H13 H12 H11 C8", hand: "ハイカード", best: false}, {card: "H10 C2 D3 D9 D10", hand: "ワンペア", best: true}])
    end

    end

  #正常系（エラーリスト）
  describe 'POST #post' do
    before{post '/api/poker', params: {cards:["H1 H13 H12 H12 C8","H10 C2 D3 D9"]}}

    it 'エラーリストが返ってくる' do
      json = JSON.parse(response.body)
      expect(json['error']).to eq([{card: "H1 H13 H12 H12 C8", msg: ["カードが重複しています。"]},{card: "H10 C2 D3 D9", msg: ["5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）"]}])
    end

  end

  #正常系（結果リストとエラーリスト）
  describe 'post #post' do
    before{post '/api/poker', params:{cards:["D13 D13 C12 S8 H1","S1 S2 S3 S4 S13"]}}

    it '結果リストとエラーリストが返ってくる' do
      json = JSON.parse(response.body)
      expect(json['result']).to eq([{card: "S1 S2 S3 S4 S13", hand: "ストレートフラッシュ", best: true}])
      expect(json['error']).to eq([{card: "D13 D13 C12 S8 H1", msg: ["カードが重複しています。"]}])
    end
  end

  #異常系（想定外のパラメーター名）
  describe 'POST #post' do
    before{post '/api/poker', params: {karuta:["H1 H13 H12 H11 C8"]}}
    it 'has a 400 http status code' do
      expect(response.status).to eq 400
    end
  end

  #異常系（想定外のHTTPリクエスト）
  describe 'POST #get' do
    before{get '/api/poker', params: {cards: ["H1 H13 H12 H11 C8"]}}
    it 'has a 405 http status code' do
      expect(response.status).to eq 405
    end
  end

  describe 'POST #delete' do
    before{delete '/api/poker', params: {cards: ["H1 H13 H12 H11 C8"]}}
    it 'has a 405 http status code' do
      expect(response.status).to eq 405
    end
  end

  #異常系（xml形式のリクエスト）
  describe 'POST #post' do
    it 'request type is xml' do

      post '/api/poker', params: {cards: ["H1 H13 H12 H11 H10"]}, headers: { "Content-Type" => "application/xml" }
     json = JSON.parse(response.body)
      expect(json['error']).to eq ("The provided content-type 'application/xml' is not supported.")
    end
end
end