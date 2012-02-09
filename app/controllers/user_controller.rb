require "digest/sha2"

class UserController < ApplicationController
  def create
    respond_to do |format|
      puts ":password = "+params[:password]
      puts ":verify_password = "+params[:verify_password]
      if params[:password] == params[:verify_password]
        @user = User.create(params[:user])
        @user.password = Digest::SHA2.hexdigest(params[:password])
        @user.save
        session[:user] = @user.email
        format.html { render "classes/new" }
      else
        puts "Passwords don't match"
        format.html { render :notice => "Passwords don't match", :action => "home/index" }
      end
    end
  end

  def login
    @user = User.where("email = ?", params[:email]).first
    hash = Digest::SHA2.hexdigest(params[:password])
    puts "pw = "+params[:password]
    puts "hashed pw = "+hash
    puts "db pw = "+@user.password
    if hash == @user.password
      session[:user] = @user.email
      render "show"
    else
      render :notice => "Invalid email or password", :action => "home/index"
    end
  end

  def logout
    session.delete :user
    render "home/index"
  end

end
