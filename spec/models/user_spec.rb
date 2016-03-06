require 'spec_helper'
require "rails_helper"

describe User do
  
  before do 
  	@user_ok = User.new(name: "Example user", email: "user@example.com",
  						password: 'foobar', password_confirmation: 'foobar')
  	@user_with_blank_name = User.new(name: " ", email: "vlad@mail.e",
  						password: 'foobar', password_confirmation: 'foobar')
  	@user_with_blank_email = User.new(name: "Meow", email: " ",
  						password: 'foobar', password_confirmation: 'foobar')
  	@user_with_invalid_email = User.new(name: "Vlad", email: "2@qwe..fs",
  						password: 'foobar', password_confirmation: 'foobar')
  	@user_with_long_name = User.new(name: "aaaaaaaaaaaaaaaaaaaaa", email: "email@e.mail",
  						password: 'foobar', password_confirmation: 'foobar')
  	@user_with_short_name = User.new(name: "aa", email: "a@a.a",
  						password: 'foobar', password_confirmation: 'foobar')
  	@user_with_valid_email = User.new(name: "Vlad", email: "vladikthebest97@gmail.com",
  						password: 'foobar', password_confirmation: 'foobar')
  	@user_with_another_valid_email = User.new(name: "Vlad", email: "yermakov.v.o@gmail.com",
  						password: 'foobar', password_confirmation: 'foobar')
  	@user_with_blank_password = User.new(name: "Woof", email: "woof@dog.com", 
  		                password: "", password_confirmation: "")
  	@user_with_different_password_and_confirmation = User.new(name: "Moo", email: "moo@cow.org",
  						password: "moomoomoo", password_confirmation: "moomoo...")
  	@user_from_example = User.new(name: "Sex", email: "sex@sex.xxx",
  						password: "iloveporn", password_confirmation: "iloveporn")
  	@user_with_short_password = User.new(name: "Vasya", email: "vasya.lover@uzhnu.edu.ua",
  						password: "aaaaa", password_confirmation: "aaaaa")
  end

  subject {@user_ok}

  it {should respond_to(:name)}
  it {should respond_to(:email)}
  it {should respond_to(:password_digest)}
  it {should respond_to(:password)}
  it {should respond_to(:password_confirmation)}
  it {should be_valid}
  it {should respond_to(:authenticate)}

  describe "when name is too short" do
    
    subject {@user_with_short_name}

    it {should_not be_valid}

  end

  describe "when name is too long" do

    subject {@user_with_long_name}

    it {should_not be_valid}

  end

  describe "when name is not valid" do
  
  	subject {@user_with_blank_name}

    it {should_not be_valid}
  
  end

  describe "when email is blank" do
  
  	subject {@user_with_blank_email}

    it {should_not be_valid}

  end

  describe "when email is not valid" do
  
    subject {@user_with_invalid_email}

    it {should_not be_valid}

  end

  describe "when all is ok" do

  	subject {@user_with_valid_email}

  	it {should be_valid}

  end

  describe "when all is ok too" do

  	subject {@user_with_another_valid_email}

  	it {should be_valid}

  end

  describe "when email is already taken" do

  	before do 

  	  @user_with_some_email_like_user_ok = @user_ok.dup
  	  @user_with_some_email_like_user_ok.email.upcase!
  	  @user_with_some_email_like_user_ok.save

  	end

  	subject {@user_with_some_email_like_user_ok}

  	it {should_not be_valid}
  
  end

  describe "when password if blank" do
    
    subject {@user_with_blank_password}

    it {should_not be_valid}

  end

  describe "when password doesn't match confirmation" do

    subject {@user_with_different_password_and_confirmation}

    it {should_not be_valid}

  end

  describe "return value of authenticate method" do
  
    subject {@user_from_example}

    before { @user_from_example.save }
    let(:found_user) { User.find_by(email: @user_from_example.email) }

    describe "with valid password" do
      
      it { should eq found_user.authenticate(@user_from_example.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      describe "" do
    
      	subject {user_for_invalid_password}
        specify { expect(user_for_invalid_password).to be false }
        it {should be false}
    
      end
    
    end
  
  end

  describe "when password too short" do

  	subject {@user_with_short_password}

  	it {should be_invalid}

  end

end