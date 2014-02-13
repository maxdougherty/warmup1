require 'test_helper'

# Recreate test database from the current environment's database schema
# rake db:test:clone

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  	SUCCESS = 1
	ERR_BAD_CREDENTIALS = -1
	ERR_USER_EXISTS = -2
	ERR_BAD_USERNAME = -3
	ERR_BAD_PASSWORD = -4
	MAX_USERNAME_LENGTH = 128
	MAX_PASSWORD_LENGTH = 128

	#test1
	test "resetFixture succeeds" do
		val = User.TESTAPI_resetFixture
		assert val == SUCCESS
	end

	#test2
	test "signup succeeds" do
		val = User.signup("test1", "test")
		assert val == SUCCESS
	end

	#test3
	test "resetFixture functions" do
		User.signup("rtest1", "testing")
		presize = User.all.length
		assert presize > 0

		val = User.TESTAPI_resetFixture
		assert val == SUCCESS

		postsize = User.all.length
		assert postsize == 0
	end

	#test4
	test "signup succeeds twice" do
		User.delete_all
		val = User.signup("test2", "testing")
		assert val == SUCCESS

		val = User.signup("test3", "testing")
		assert val == SUCCESS
	end

	#test5
	test "signup functions" do
		User.delete_all
		val = User.signup("test4", "testing")
		assert val == SUCCESS

		acc = User.where(user: "test4")
		assert (not acc.nil?)
	end

	#test6
	test "signin succeeds" do
		User.delete_all
		val = User.signup("test5", "testing")
		assert val == SUCCESS

		val = User.signin("test5", "testing")
		assert val == SUCCESS
	end

	#test7
	test "signin fails bad password" do
		User.delete_all
		val = User.signup("test6", "testing")
		assert val == SUCCESS

		val = User.signin("test6", "badpass")
		assert val == ERR_BAD_CREDENTIALS
	end

	#test8
	test "db reset functions by add" do
		User.delete_all
		val = User.signup("test7", "testing")
		assert val == SUCCESS

		val = User.TESTAPI_resetFixture
		assert val == SUCCESS

		val = User.signup("test7", "testing")
		assert val == SUCCESS
	end

	#test9
	test "signup fails with no user" do
		User.delete_all
		val = User.signup("", "testing")
		assert val == ERR_BAD_USERNAME
	end

	#test10
	test "signup fails with bad password" do
		User.delete_all
		pass = ""
		index = 1
		while index < 130
			pass = pass + "x"
			index += 1
		end

		val = User.signup("test8", pass)
		assert val == ERR_BAD_PASSWORD
	end
end














