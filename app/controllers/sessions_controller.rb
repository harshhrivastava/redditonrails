class SessionsController < ApplicationController

  def new

    if @current_user

      redirect_to root_path

      return

    end

  end

  def create
    
    user = User.find_by(email: params[:email])

    if user

      if user.authenticate(params[:password])

        access_token = generate_access_token(user)

        refresh_token = generate_refresh_token(user)

        cookies[:access_token] = {
          value: access_token,
          expires: 10.minutes.from_now,
          httponly: true
        }

        cookies[:refresh_token] = {
          value: refresh_token,
          expires: 30.days.from_now,
          httponly: true
        }

        redirect_to root_path

        return

      else

        flash[:alert] = "Invalid email or password."

        redirect_to login_path

        return

      end

    else

      flash[:alert] = "User not found. Please create an account."

      redirect_to login_path

      return

    end
  
  end

  def destroy

    cookies.delete(:access_token)

    cookies.delete(:refresh_token)

    redirect_to root_path
  
  end

end
