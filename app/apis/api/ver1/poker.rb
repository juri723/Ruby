require "net/http"

module API
  module Ver1
    include Cards::CardsService #ServiceをAPIでも利用できるようにする。
    class Poker < Grape::API
      version 'v1', using: :header, vendor: 'api'
      format :json

      # `cards`resource配下にすることで/api/ver1/pokerのapiとしてアクセスできる
      resources :poker do

        # POST http://[host]/api/poker
        params do
          requires :cards, type: Array
        end

        # 入力された値をチェックし、ポーカーの役判定を行う。
        post do
          error!("不正なパラメータが含まれてます。", 400) unless params.keys == ["cards"]
          Cards::CardsService.result(params[:cards])
        end
      end
    end
  end
end