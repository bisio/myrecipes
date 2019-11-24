require 'test_helper'

class ChefTest < ActiveSupport::TestCase
    def setup
        @chef = Chef.new(chefname: "bisio", email: "andrea.bisognin@gmail.com")
    end

    test "should be valid" do
        assert @chef.valid?
    end

    test "name should be present" do
        @chef.chefname = ""
        assert_not @chef.valid?
    end

    test "name should be less then 30 chars" do
        @chef.chefname = "a" * 31
        assert_not @chef.valid?
    end

    test "email should be present" do
        @chef.email = ""
        assert_not @chef.valid?
    end

    test "email should be not be too long" do
        @chef.email = "a" * 256 + "@example.com"
        assert_not @chef.valid?
    end

    test "email should be in valid format" do
        valid_emails = %w[test@example.com MAS@gmail.com M.first@yahoo.ca john+smith@co.uk.org]
        valid_emails.each do |email|
            @chef.email = email
            assert @chef.valid?, "#{email.inspect} should be valid"
        end
    end

    test "should reject invalid addresses" do 
        invalid_emails = %w[diocane@gmail diocane@example,com]
        invalid_emails.each do |email|
            @chef.email = email 
            assert_not @chef.valid?, "#{email.inspect} should be invalid"
        end
    end

    test "email should be unique and case insensitive" do 
        duplicate_chef = @chef.dup
        duplicate_chef.email = @chef.email.upcase 
        @chef.save
        duplicate_chef.save
        assert_not duplicate_chef.valid?    
    end

    test "email should be lower case before hitting db" do
        mixed_email = "ANDrea.bisognin@gmail.com"
        @chef.email =  mixed_email
        @chef.save 
        assert_equal mixed_email.downcase, @chef.reload.email   
    end

        
end


