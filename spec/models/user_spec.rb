require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar" ) }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }

  it { should be_valid }
  it { should_not be_admin }

  describe "when admin attribute set to true" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w(user@foo,com user_at_foo.com example_user@foo@bar.com user@foo+bar.com user@example..com)

      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w(user@FOO.com a_b-c@d-e.com a+b@foo.com a.b@c.d.com)

      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when email address is submitted with mixed case" do
    let(:mixed_case_email) { "UsEr@ExAmPlE.CoM" }

    it "should be stored in all lower case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com", password: " ", password_confirmation: " " )
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match password confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when signing in with correct password" do
    before { @user.save }
    it "should authenticate" do
      expect(@user).to eq @user.authenticate("foobar")
    end
  end

  describe "when signing in with wrong password" do
    before { @user.save }
    it "shouldn't authenticate" do
      expect(@user.authenticate("invalid")).to be_false
    end
  end

  describe "when trying to set a password shorter than 6 characters" do
    before { @user.password = @user.password_confirmation = "12345" }
    it { should_not be_valid }
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
end
