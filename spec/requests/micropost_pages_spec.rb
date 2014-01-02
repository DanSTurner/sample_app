require 'spec_helper'

describe "MicropostPages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do
      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content("error") }
      end
    end

    describe "with valid information" do

      before  { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count)
      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as the correct user" do
      describe "at the home page" do
        before { visit root_path }

        it "should delete a micropost" do
          expect { click_link "delete" }.to change(Micropost, :count).by(-1)
        end
      end
      describe "at the profile page" do
        before { visit user_path(user) }

        it "should delete a micropost" do
          expect { click_link "delete" }.to change(Micropost, :count).by(-1)
        end
      end
    end

    describe "as a different user" do
      let(:different_user) { FactoryGirl.create(:user) }
      before do
        sign_in different_user
        visit user_path(user)
      end

      it { should_not have_link("delete") }
    end
  end

  describe "micropost pagination" do
    before { 31.times { FactoryGirl.create(:micropost, user: user) } }
    after(:all)  { User.delete_all }

    describe "on home page" do
      before { visit root_path }

      it { should have_selector('div.pagination') }

      it "should list each micropost" do
        Micropost.paginate(page: 1).each do |micropost|
          expect(page).to have_selector('li', text: micropost.content)
        end
      end
    end

    describe "on profile page" do
      before { visit user_path(user) }

      it { should have_selector('div.pagination') }

      it "should list each micropost" do
        Micropost.paginate(page: 1).each do |micropost|
          expect(page).to have_selector('li', text: micropost.content)
        end
      end
    end
  end
end
