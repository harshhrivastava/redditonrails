class CommentsController < ApplicationController
    def show
        @comment = Comment.find(params[:id])
        @replies = @comment.comments

        render :json => ({comment: @comment, replies: @replies, comment_path: @comment.path})
    end

    def new
        if params[:comment_id].present?
            @parent_object = Comment.find(params[:comment_id])
        else
            @parent_object = Subreddit.find(params[:subreddit_id])
        end
        @comment = @parent_object.comments.build
    end

    def create
        if params[:comment_id].present?
            @parent_object = Comment.find(params[:comment_id])
        else
            @parent_object = Subreddit.find(params[:subreddit_id])
        end
        @comment = @parent_object.comments.new(get_comment_attributes)
        
        if @comment.save
            redirect_to subreddit_path(@parent_object)
        else
            render :new
        end
    end

    def edit
        @comment = Comment.find(params[:id])
    end

    def update
        @comment = Comment.find(params[:id])

        if @comment.update(get_comment_attributes)
          redirect_to @comment
        else
          render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @comment = Comment.find(params[:id])
        @comment.destroy

        redirect_to root_path
    end
    
    private

    def get_comment_attributes
        params.require(:comment).permit(:comment, :commenter, :commentable_type, :commentable_id)
    end

end
