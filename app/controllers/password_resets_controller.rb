class PasswordResetsController < ApplicationController
  before_action :get_user, only:[:edit, :update]
  before_action :vaild_user, only:[:edit, :update]
  #1)パスワード再設定の有効期限が切れていないか
  before_action :check_expiration, only:[:edit, :update]
  
  def new
  end
  
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "パスワードリセットメールを送信しました" 
      redirect_to root_url
    else
      flash.now[:danger] = "無効なメールアドレスです"
      render 'new'
    end  
  end

  def edit
  end
  
  def update
    #3)新しいパスワードが空文字列になっていないか（ユーザー情報の編集ではOKだった）
    if params[:user][:password].empty? 
      #4)新しいパスワードが正しければ、更新する
      @user.errors.add(:password, :blank) 
      render 'edit' 
    elsif @user.update(user_params)
      log_in @user
      #パスワード再設定が成功したらダイジェストをnilにする
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "パスワードがリセットされました"
      redirect_to @user
    else
      render 'edit'#2)無効なパスワードであれば失敗させる（失敗した理由も表示する）
    end  
  end


private
  
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end  

  def get_user
    @user = User.find_by(email: params[:email])
  end
  
     # 有効なユーザーかどうか確認する
  def vaild_user
    unless(@user && @user.activated? && @user.authenticated?(:reset,params[:id]))
      redirect_to root_url
    end  
  end
  
   # トークンが期限切れかどうか確認する
  def check_expiration
    if @user.password_reset_expired?
      flash[:denger] = "パスワードのリセットの有効期限が切れています。"
      redirect_to new_password_reset_url
    end
  end  
end  
