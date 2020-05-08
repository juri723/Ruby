module API
  module Ver1
    include Cards::CardsService #ServiceをControllerでも利用できるようにする。
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
          cards = params[:cards]
          responses = Cards::CardsService.judge(cards)
          responses
        end

        #post以外でのHTTPリクエストの時
        get do
          error!("not allowed",405)
        end

        delete do
          error!("not allowed",405)
        end

      end
    end
  end
end
