class UsersController < ApplicationController
  def index
  	
  end

  #log in a user to the database
  def login
  	@dbreturn = User.signin(params[:user], params[:password])
  	if @dbreturn > 0
  		@user = User.where(:user => params[:user]).first
  # 		respond_to do |f|
  # 			f.json { render json: {:errCode => 1, :count => @user.count}}
  # 			f.html { render :add }
		# end 
		render json: {:errCode => 1, :count => @user.count}
  		
	else

		# respond_to do |f|
		# 	f.json { render json: {:errCode => @dbreturn}}
		# 	f.html { render :index, :flash => {:error => "STRING"}}
			
		# end
		render json: {:errCode => @dbreturn}

		
	end
  end


  #add a user to the database
  def add
 
  	@dbreturn = User.signup(params[:user], params[:password])
  	if @dbreturn > 0
  		@user = User.where(:user => params[:user]).first
  # 		respond_to do |f|
  # 			f.json { render json: {:errCode => 1, :count => 1}}
  # 			f.html { render :add }
  			
		# end 
		render json: {:errCode => 1, :count => 1}
  		
	else

		# respond_to do |f|
		# 	f.json { render json: {:errCode => @dbreturn}}
		# 	f.html { render :index, :flash => {:error => "STRING"}}
			
		# end
		render json: {:errCode => @dbreturn}
		
	end

  end


  def resetFixture
  	User.TESTAPI_resetFixture
  	# respond_to do |f|
  	# 	f.json {render json: {:errCode => 1}}
  		# f.html { render :index}
	render json: {:errCode => 1}
	# end

  end

  #TODO: WTF WHY NOT WORK OUTPUT BAD? WHY SPLIT FAIL?
  def unitTests
  	@unitVal = `ruby -Itest test/unit/user_test.rb`
  	@numTests = @unitVal.scan(/^\d+ tests,/).first.split.first
  	@numTests = Integer(@numTests)
  	@numFailures = @unitVal.scan(/\s\d+ failures,/).first.split.first
  	@numFailures = Integer(@numFailures)
  	render json: {totalTests: @numTests, output: @unitVal, nrFailed: @numFailures}
  end

end








