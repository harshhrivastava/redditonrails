class SubredditsController < ApplicationController

    def index

        @page_number = 0

        if params[:page].present?

            @page_number = params[:page].to_i
            
        end

        all_subreddits = Subreddit.all

        start_index = @page_number * 5

        end_index = start_index + 4

        @subreddits = all_subreddits[start_index..end_index]

        @total_pages = (all_subreddits.size) / 5

        if @page_number > @total_pages

            render :json => ({error: ["Index out of bound. Last index is " + @total_pages.to_s]})

        else
        
            render :json => ({subreddits: @subreddits, current_page: @page_number + 1, total_pages: @total_pages + 1})

        end

    end

    def show

        if params[:page].present?

            @page_number = params[:page].to_i

            @subreddit = Subreddit.find(params[:subreddit_id])

            @id = params[:subreddit_id]

        elsif params[:id].present?

            @page_number = 0

            @subreddit = Subreddit.find(params[:id])

            @id = params[:id]

        end

        all_comments = @subreddit.comments

        start_index = @page_number * 5

        end_index = start_index + 4

        @comments = all_comments[start_index..end_index]

        @total_pages = (all_comments.size) / 5

        if @page_number > @total_pages

            render :json => ({error: ["Index out of bound. Last index is " + @total_pages.to_s]})

        else

            render :json => ({subreddit: @subreddit, comments: @comments, id: @id, current_page: @page_number + 1, total_pages: @total_pages + 1})
        
        end
        
    end
    
    def new
    
        @subreddit = Subreddit.new
    
    end

    def create
    
        @subreddit = Subreddit.new(get_subreddit_params)

        if @subreddit.save
    
            redirect_to @subreddit
    
        else
    
            render :new, status: :unprocessable_entity
    
        end
    
    end

    def edit
    
        @subreddit = Subreddit.find(params[:id])
    
    end

    def update
    
        @subreddit = Subreddit.find(params[:id])

        if @subreddit.update(get_subreddit_params)
    
            redirect_to @subreddit
    
        else
    
            render :edit, status: :unprocessable_entity
    
        end
    
    end
    
    def destroy
    
        @subreddit = Subreddit.find(params[:id])
    
        @subreddit.destroy

        redirect_to root_path
    
    end

    private

    def get_subreddit_params
    
        params.require(:subreddit).permit(:title, :body)
    
    end

end