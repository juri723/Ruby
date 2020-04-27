#require 'grape'
module API
  module Ver1
    class Root < Grape::API
      mount API::Ver1::Poker
    end
  end
end