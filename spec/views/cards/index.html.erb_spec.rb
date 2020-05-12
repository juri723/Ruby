require 'rails_helper'
require 'capybara/rspec'

Capybara.default_driver = :selenium
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

feature 'shows hands' do
  scenario 'ストレートフラッシュ' do
    #トップページを開く
    visit "/cards/index"
    #フォームに5枚のカードの値を入力する
    fill_in "S10 H11 D12 C13 H1", with:'H10 H11 H13 H12 H1'
    #checkボタンをクリックする
    click_on 'check'
    # 入力したフォームの値がセットされているか
    expect(page).to have_field 'cards', with:'H10 H11 H13 H12 H1'
    #役名が表示されているか
    expect(page).to have_content 'ストレートフラッシュ'
  end
  scenario 'フォー・オブ・ア・カインド' do
    #トップページを開く
    visit "/cards/index"
    #フォームに5枚のカードの値を入力する
    fill_in "S10 H11 D12 C13 H1", with:'D5 D6 H6 S6 C6'
    #checkボタンをクリックする
    click_on 'check'
    # 入力したフォームの値がセットされているか
    expect(page).to have_field 'cards', with:'D5 D6 H6 S6 C6'
    #役名が表示されているか
    expect(page).to have_content 'フォー・オブ・ア・カインド'
  end
  scenario 'フルハウス' do
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
  scenario 'フラッシュ' do
    #トップページを開く
    visit "/cards/index"
    #フォームに5枚のカードの値を入力する
    fill_in "S10 H11 D12 C13 H1", with:'S13 S12 S11 S9 S6'
    #checkボタンをクリックする
    click_on 'check'
    # 入力したフォームの値がセットされているか
    expect(page).to have_field 'cards', with:'S13 S12 S11 S9 S6'
    #役名が表示されているか
    expect(page).to have_content 'フラッシュ'
  end
  scenario 'ストレート' do
    #トップページを開く
    visit "/cards/index"
    #フォームに5枚のカードの値を入力する
    fill_in "S10 H11 D12 C13 H1", with:'D6 S5 D4 H3 C2'
    #checkボタンをクリックする
    click_on 'check'
    # 入力したフォームの値がセットされているか
    expect(page).to have_field 'cards', with:'D6 S5 D4 H3 C2'
    #役名が表示されているか
    expect(page).to have_content 'ストレート'
  end
  scenario 'スリー・オブ・ア・カインド' do
    #トップページを開く
    visit "/cards/index"
    #フォームに5枚のカードの値を入力する
    fill_in "S10 H11 D12 C13 H1", with:'D9 C10 H1 C1 S1'
    #checkボタンをクリックする
    click_on 'check'
    # 入力したフォームの値がセットされているか
    expect(page).to have_field 'cards', with:'D9 C10 H1 C1 S1'
    #役名が表示されているか
    expect(page).to have_content 'スリー・オブ・ア・カインド'
  end
  scenario 'ツーペア' do
    #トップページを開く
    visit "/cards/index"
    #フォームに5枚のカードの値を入力する
    fill_in "S10 H11 D12 C13 H1", with:'D10 C10 H1 H2 S1'
    #checkボタンをクリックする
    click_on 'check'
    # 入力したフォームの値がセットされているか
    expect(page).to have_field 'cards', with:'D10 C10 H1 H2 S1'
    #役名が表示されているか
    expect(page).to have_content 'ツーペア'
  end
  scenario 'ワンペア' do
    #トップページを開く
    visit "/cards/index"
    #フォームに5枚のカードの値を入力する
    fill_in "S10 H11 D12 C13 H1", with:'D10 C10 H1 H2 S3'
    #checkボタンをクリックする
    click_on 'check'
    # 入力したフォームの値がセットされているか
    expect(page).to have_field 'cards', with:'D10 C10 H1 H2 S3'
    #役名が表示されているか
    expect(page).to have_content 'ワンペア'
  end
  scenario 'ハイカード' do
    #トップページを開く
    visit "/cards/index"
    #フォームに5枚のカードの値を入力する
    fill_in "S10 H11 D12 C13 H1", with:'D1 D10 S9 C5 C4'
    #checkボタンをクリックする
    click_on 'check'
    # 入力したフォームの値がセットされているか
    expect(page).to have_field 'cards', with:'D1 D10 S9 C5 C4'
    #役名が表示されているか
    expect(page).to have_content 'ハイカード'
  end
end

feature 'shows error message' do
  scenario 'カードが重複している' do
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
  scenario 'カードが4枚' do
    #トップページを開く
    visit "/cards/index"
    #フォームに5枚のカードの値を入力する
    fill_in "S10 H11 D12 C13 H1", with:'D10 C10 H10 H2'
    #checkボタンをクリックする
    click_on 'check'
    # 入力したフォームの値がセットされているか
    expect(page).to have_field 'cards', with:'D10 C10 H10 H2'
    #エラーメッセージが表示されているか
    expect(page).to have_content '5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）'
  end
  scenario '不正なカード' do
    #トップページを開く
    visit "/cards/index"
    #フォームに5枚のカードの値を入力する
    fill_in "S10 H11 D12 C13 H1", with:'D10 C10 H10 P2 C9'
    #checkボタンをクリックする
    click_on 'check'
    # 入力したフォームの値がセットされているか
    expect(page).to have_field 'cards', with:'D10 C10 H10 P2 C9'
    #エラーメッセージが表示されているか
    expect(page).to have_content '4番目のカード指定文字が不正です。(P2)'
  end
end