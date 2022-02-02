require 'rails_helper'

RSpec.feature 'User registration', type: :feature, ui: true do
  given!(:contest) { create :contest }
  given(:registration_path) { "/contests/#{contest.id}/users/new" }

  before { visit registration_path }
  before { fill_new_user_form params }

  context 'with everything valid' do
    given(:params) { attributes_for :user }
    before { click_button 'commit' }
    scenario { expect(page).to have_content 'Ви успішно зареєстровані.' }
  end
end