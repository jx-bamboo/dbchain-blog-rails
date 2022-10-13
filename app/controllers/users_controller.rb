class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  # invisible_captcha only: [:create, :update], honeypot: :subtitle

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    p params,"||||"
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:user] = @user
        format.html { redirect_to articles_path, notice: "User was successfully updated." }
        # format.html { redirect_to @user, notice: "User was successfully created." }
        # format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        # format.html { redirect_to @user, notice: "User was successfully updated." }
        # format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def sms
    check_phone_number_result = PhoneArea.check(params[:phone])

    if check_phone_number_result[:sp].empty? || !verify_rucaptcha?
      render plain: '电话号码或验证码不正确'
    else
      redis = Redis.new
      redis_phone = redis.get(params[:phone])
			if redis_phone.nil?
				code = sms_code(6)
				p code,"|"
				re = Aliyun::CloudSms.send_msg(params[:phone], 'SMS_192960014', {"code": code})
				p re,"||"
				redis.set(params[:phone], code+",#{Time.now.to_i}")
				render plain: "ok"
			else
				old_time = redis.get(params[:phone]).split(",")[1]
				count_time = (Time.now.to_i-old_time.to_i)/60
				if count_time > 5
					code = sms_code(6)
					p code,"||"
					re = Aliyun::CloudSms.send_msg(params[:phone], 'SMS_192960014', {"code": code})
					redis.set(params[:phone], code+",#{Time.now.to_i}")
					render plain: 'ok'
				else
					render plain: '5minits'
				end
			end
    end
  end

  def login
    if request.post?
      user = User.find_by(phone_number: params[:phone_number]).try(:authenticate, params[:password])
      if user
        session[:user] = user
        redirect_to root_path, notice: '登录成功'
      else
        redirect_to login_path, notice: '账号或密码不正确'
      end
    end
  end

  def sign_out
    session[:user] = nil
    redirect_to root_path, notice: '登出成功'
  end

  def info
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:phone_number, :password, :password_confirmation)
    end
end
