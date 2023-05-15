class UsersController < ApplicationController

  before_action :refresh, except: [:create]
  
  def new

    if current_user

      flash[:notice] = "You are already logged in."

      redirect_to root_path

      return

    else

      @user = User.new

    end

  end

  def create

    user = User.find_by({email: params[:user][:email]})

    if user.present?

      flash.now[:notice] = "Email already exists. <%= link_to 'Log in to continue', login_path %>."
      
      render :new

      return

    else

      @user = User.new(get_user_params)

      if @user.save

        flash[:success] = "Account created successfully."

        redirect_to login_path(email: @user.email, password: @user.password)

        return

      else

        flash.now[:alert] = "There was some error in creating your account. Please make sure that input fields are correctly filled."

        render :new, status: :unprocessable_entity

        return

      end
    
    end

  end
  
  def edit
    
    @user = current_user

  end
  
  def update

    if current_user.update(get_user_params_for_update)

      flash[:notice] = "User updated successfully."
      
      redirect_to root_path

      return
    
    else

      render :edit

      return

    end
    
  end

  def destroy

    @user = current_user

    session[:user_id] = nil

    @user.destroy

    redirect_to root_path

    return
    
  end

  private

  def get_user_params
  
    params.require(:user).permit(:fname, :lname, :email, :password, :password_confirmation)

  end

  def get_user_params_for_update
  
    params.require(:user).permit(:fname, :lname)

  end

end