FactoryGirl.define do
  factory :user do
    name                    "Tester McTestington"
    email                   "test@mctestingtonfamily.com"
    password                "foobar"
    password_confirmation   "foobar"
  end
end