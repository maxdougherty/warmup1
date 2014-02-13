class User < ActiveRecord::Base

	SUCCESS = 1
	ERR_BAD_CREDENTIALS = -1
	ERR_USER_EXISTS = -2
	ERR_BAD_USERNAME = -3
	ERR_BAD_PASSWORD = -4
	MAX_USERNAME_LENGTH = 128
	MAX_PASSWORD_LENGTH = 128


	def self.signup(username, pass)
		if (username.length > MAX_USERNAME_LENGTH) || (username.length < 1)
			return ERR_BAD_USERNAME
		end

		if (pass.length > MAX_PASSWORD_LENGTH) || (pass.length < 1)
			return ERR_BAD_PASSWORD
		end

		user = User.where(user: username).first

		unless user.nil?
			return ERR_USER_EXISTS
		else
			user = User.new(user: username, password: pass, count: 1)
			user.save
			return SUCCESS
		end

	end

	def self.signin(username, pass)
		if (username.length > MAX_USERNAME_LENGTH) || (username.length < 1)
			return ERR_BAD_USERNAME
		end

		if (pass.length > MAX_PASSWORD_LENGTH) || (pass.length < 1)
			return ERR_BAD_PASSWORD
		end

		user = User.where(user: username, password: pass).first

		if user.nil?
			return ERR_BAD_CREDENTIALS
		else
			user.count = user.count + 1
			user.save
			return SUCCESS
		end
	end

	def self.TESTAPI_resetFixture
		User.delete_all
		return SUCCESS
	end
end
