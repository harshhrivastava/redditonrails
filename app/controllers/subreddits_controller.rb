class SubredditsController < ApplicationController

    before_action :authenticate_user!, except: [:index, :show]

    before_action :set_subreddit, only: [:edit, :update, :destroy]

    def index

        @page_number = 0

        if params[:page].present?

            @page_number = params[:page].to_i
            
        end

        @subreddits = Subreddit.all

        start_index = @page_number * 5

        end_index = start_index + 4
        
        @total_pages = ((@subreddits.size - 1) / 5)

        @subreddits = @subreddits[start_index..end_index]

        if current_user

            @user = current_user

        end

        if @page_number > @total_pages

            render :json => ({error: ["Index out of bound. Last index is " + @total_pages.to_s]})

            return

        # else

        #     render :json => ({subreddits: @subreddits, page_number: @page_number + 1, total_pages: @total_pages + 1})

        end

    end

    def show

        if params[:page].present?

            @page_number = params[:page].to_i

            begin

                @subreddit = Subreddit.find(params[:subreddit_id])
                
            rescue => exception

                flash[:alert] = exception

                redirect_to root_path
                
            else

                @id = params[:subreddit_id]
                
            end

        elsif params[:id].present?

            @page_number = 0

            begin

                @subreddit = Subreddit.find(params[:id])
                
            rescue ActiveRecord::RecordNotFound => exception

                flash[:alert] = "Subreddit not found."

                redirect_to root_path
                
            else

                @id = params[:id]
                
            end


        end

        all_comments = Comment.where({commentable_id: @id, commentable_type: "Subreddit"})

        start_index = @page_number * 5

        end_index = start_index + 4

        @comments = all_comments[start_index..end_index]

        @total_pages = (all_comments.size) / 5

        @user = @current_user

        if @page_number > @total_pages

            render :json => ({error: ["Index out of bound. Last index is " + @total_pages.to_s]})

        # else

        #     render :json => ({subreddit: @subreddit, comments: @comments, id: @id, current_page: @page_number + 1, total_pages: @total_pages + 1})
        
        end
        
    end
    
    def new

        if current_user

            @user_id = current_user[:id]

            @author = current_user[:fname] + " " + current_user[:lname]
            
            @subreddit = current_user.subreddits.build

        else

            redirect_to login_path

        end

    end

    def create
    
        @subreddit = current_user.subreddits.new(get_subreddit_params_for_create)

        if @subreddit.save
    
            redirect_to root_path
    
        else
    
            flash[:alert] = "Error saving post"

            render :new, status: :unprocessable_entity
    
        end
    
    end

    def edit
    
    end

    def update

        if @subreddit.update(get_subreddit_params)
    
            redirect_to @subreddit
    
        else

            flash[:alert] = "Unable to save your subreddit"
    
            render :edit
    
        end
    
    end
    
    def destroy
    
        @subreddit.destroy

        redirect_to root_path
    
    end

    private

    def get_subreddit_params
    
        params.require(:subreddit).permit(:title, :body)
    
    end

    def get_subreddit_params_for_create
    
        subreddit_params = params.require(:subreddit).permit(:title, :body, :user_id, :author)
    
    end

    def set_subreddit

        @subreddit = Subreddit.find(params[:id])

    end

end