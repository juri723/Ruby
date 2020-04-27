#require 'grape'
module API
  class Root < Grape::API
    mount API::Ver1::Root
  end
end