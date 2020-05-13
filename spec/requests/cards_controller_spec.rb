require 'rails_helper'

RSpec.describe CardsController, type: :controller do
  include Constants

  #正常系
  describe 'POST #post' do
    before{post :post, params:{cards:"H10 C2 D3 D9 D10"}}

   it 'renders the :index template' do
    expect(response).to render_template :index
   end

   it 'has a 200 status code' do
    expect(response).to have_http_status(:ok)
   end

   it 'assigns @card' do
     expect(assigns(:card)).to eq "H10 C2 D3 D9 D10"
   end

    it 'assigns @msg' do
      expect(assigns(:msg)).to eq nil
    end

    it 'assigns @result' do
      expect(assigns(:result)).to eq Constants::Hands::Result[1]
    end

  end

  #異常系
  describe 'POST #post' do
    before{post :post, params:{cards:"H10 C2 D8 S8"}}

    it 'renders the :index template' do
      expect(response).to render_template :index
    end

    it 'has a 200 status code' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @card' do
      expect(assigns(:card)).to eq "H10 C2 D8 S8"
    end

    it 'assigns @msg' do
      expect(assigns(:msg)).to eq [Constants::Error::ERR_MSG_INVALID_STYLE]
    end

    it 'assigns @result' do
      expect(assigns(:result)).to be nil
    end

  end

end
