class CommentsController < ApplicationController
    def show
        @comment = Comment.find(params[:id])
        @subcomments = Comment.where({commentable_id: params[:id]})
    end

    def new
        if params[:subreddit_id].present?
            @subreddit = Subreddit.find(params[:subreddit_id])
            @comment = @subreddit.comments.build
            @url = subreddit_comments_path(@subreddit)
        elsif params[:comment_id].present?
            @parent_comment = Comment.find(params[:comment_id])
            @comment = @parent_comment.subcomments.build
            @url = comment_comments_path(@parent_comment)
        end
    end

    def create
        if params[:subreddit_id].present?
            @subreddit = Subreddit.find(params[:subreddit_id])
            @comment = @subreddit.comments.build({
                commenter: params[:comment][:commenter],
                comment: params[:comment][:comment],
                commentable_type: "Comment",
                commentable_id: params[:subreddit_id],
            })
            @path = subreddit_path(@subreddit)
        elsif params[:comment_id].present?
            @parent_comment = Comment.find(params[:parent_comment])
            @comment = @parent_comment.subcomments.build({
                commenter: params[:comment][:commenter],
                comment: params[:comment][:comment],
                commentable_type: "Subcomment",
                commentable_id: params[:comment_id],
            })
            @path = comment_path(@parent_comment)
        end

        if @comment.save
            redirect_to @path
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
          redirect_to @object
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
        params.require(:comment).permit(:comment)
    end

end
