require 'rails_helper'

RSpec.feature 'User registration', type: :feature, ui: true do
  given(:registration_path) { "/contests/#{contest.id}/users/new" }
  before { visit registration_path }

  context 'for contest with contest_site, institution and city' do
    given!(:contest) { create :contest }

    before { fill_inputs 'user', params.slice(:name, :email, :registration_secret) }
    before { fill_selects 'user', params.slice(:city, :institution, :contest_site, :grade) }

    context 'with everything valid' do
      given(:params) { attributes_for :user }
      before { click_button 'commit' }
      scenario { expect(page).to have_content 'Ви успішно зареєстровані.' }
    end

    context 'with duplicated name' do
      before { create :user, contest: }
      given(:params) { attributes_for :user }
      before { click_button 'commit' }

      scenario { expect(page).to have_content "Учасник на ім'я #{params[:name]} вже зареєстрований" }
    end

    context 'with invalid registration secret' do
      given(:params) { attributes_for :user, registration_secret: SecureRandom.base36 }
      before { click_button 'commit' }
      scenario { expect(page).to have_content 'Код доступу помилковий' }
    end

    context 'without contest site' do
      given(:params) { attributes_for :user, contest_site: nil }
      before { click_button 'commit' }
      scenario { expect(page).to have_content 'Заклад, у якому ви пишете олімпіаду не може бути порожнім' }
    end

    context 'without grade' do
      given(:params) { attributes_for :user, grade: nil }
      before { click_button 'commit' }
      scenario { expect(page).to have_content 'Клас не може бути порожнім' }
    end

    context 'without city' do
      given(:params) { attributes_for :user, city: nil }
      before { click_button 'commit' }
      scenario { expect(page).to have_content 'Місто не може бути порожнім' }
    end

    context 'without email' do
      given(:params) { attributes_for :user, email: nil }
      before { click_button 'commit' }
      scenario('should stay on registration page') { expect(page).to have_current_path(registration_path) }
      scenario { expect(page).to have_no_content 'Ваш e-mail не може бути порожнім' }
    end

    context 'without institution' do
      given(:params) { attributes_for :user, institution: nil }
      before { click_button 'commit' }
      scenario { expect(page).to have_content 'Ваш навчальний заклад не може бути порожнім' }
    end

    context 'without name' do
      given(:params) { attributes_for :user, name: nil }
      before { click_button 'commit' }
      scenario('should stay on registration page') { expect(page).to have_current_path(registration_path) }
      scenario { expect(page).to have_no_content 'Прізвище, Ім\'я, По батькові не може бути пустим' }
    end
  end

  context 'for contest without contest_site' do
    given!(:contest) { create :contest, contest_sites: [] }

    before { fill_inputs 'user', params.slice(:name, :email, :contest_site, :registration_secret) }
    before { fill_selects 'user', params.slice(:city, :institution, :grade) }

    context 'with everything valid' do
      given(:params) { attributes_for :user }
      before { click_button 'commit' }
      scenario { expect(page).to have_content 'Ви успішно зареєстровані.' }
    end

    context 'without contest_site' do
      given(:params) { attributes_for :user, contest_site: nil }
      before { click_button 'commit' }
      scenario('should stay on registration page') { expect(page).to have_current_path(registration_path) }
      scenario { expect(page).to have_no_content 'Заклад, у якому ви пишете олімпіаду не може бути порожнім' }
    end
  end

  context 'for contest without institution' do
    given!(:contest) { create :contest, institutions: [] }

    before { fill_inputs 'user', params.slice(:name, :institution, :email, :registration_secret) }
    before { fill_selects 'user', params.slice(:contest_site, :city, :grade) }

    context 'with everything valid' do
      given(:params) { attributes_for :user }
      before { click_button 'commit' }
      scenario { expect(page).to have_content 'Ви успішно зареєстровані.' }
    end

    context 'without institution' do
      given(:params) { attributes_for :user, institution: nil }
      before { click_button 'commit' }
      scenario('should stay on registration page') { expect(page).to have_current_path(registration_path) }
      scenario { expect(page).to have_no_content 'Ваш навчальний заклад не може бути порожнім' }
    end
  end

  context 'for contest without city' do
    given!(:contest) { create :contest, cities: [] }

    before { fill_inputs 'user', params.slice(:name, :email, :city, :registration_secret) }
    before { fill_selects 'user', params.slice(:contest_site, :institution, :grade) }

    context 'with everything valid' do
      given(:params) { attributes_for :user }
      before { click_button 'commit' }
      scenario { expect(page).to have_content 'Ви успішно зареєстровані.' }
    end

    context 'without city' do
      given(:params) { attributes_for :user, city: nil }
      before { click_button 'commit' }
      scenario('should stay on registration page') { expect(page).to have_current_path(registration_path) }
      scenario { expect(page).to have_no_content 'Місто не може бути порожнім' }
    end
  end
end
