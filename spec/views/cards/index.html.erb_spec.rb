require 'rails_helper'
require 'capybara/rspec'

Capybara.default_driver = :selenium
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

feature 'shows hands' do
  scenario 'ポーカーの役判定を行う' do
    #トップページを開く
    visit "/cards/index"
    #フォームに5枚のカードの値を入力する
    fill_in "S10 H11 D12 C13 H1", with:'D10 C10 H10 H2 S2'
    #checkボタンをクリックする
    click_on 'check'
    # 入力したフォームの値がセットされているか
    expect(page).to have_field 'cards', with:'D10 C10 H10 H2 S2'
    #役名が表示されているか
    expect(page).to have_content 'フルハウス'
  end
end

feature 'shows error message' do
  scenario 'ポーカーの役判定を行う' do
    #トップページを開く
    visit "/cards/index"
    #フォームに5枚のカードの値を入力する
    fill_in "S10 H11 D12 C13 H1", with:'D10 C10 H10 H2 H2'
    #checkボタンをクリックする
    click_on 'check'
    # 入力したフォームの値がセットされているか
    expect(page).to have_field 'cards', with:'D10 C10 H10 H2 H2'
    #エラーメッセージが表示されているか
    expect(page).to have_content 'カードが重複しています。'
  end
end