class SubredditsController < ApplicationController

    def index
        @subreddits = Subreddit.all
        render :json => ({subreddits: @subreddits})
    end

    def show
        @subreddit = Subreddit.find(params[:id])
        render :json => ({subreddit: @subreddit, comments: @subreddit.comments})
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