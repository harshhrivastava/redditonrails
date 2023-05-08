class CommentsController < ApplicationController

    def show

        @comment = Comment.find(params[:id])

        @replies = @comment.comments

        @sibling_comments = {before: @comment.comments_before_comment(@comment), after: @comment.comments_after_comment(@comment)}

        # @comment_path = @comment.path

        render :json => ({comment: @comment, replies: @replies, comment_path: @comment.path[0..-2], siblings: @sibling_comments})

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

            @path = comment_path(@parent_object)
        
        else
            
            @parent_object = Subreddit.find(params[:subreddit_id])

            @path = subreddit_path(@parent_object)
        
        end
        
        @comment = @parent_object.comments.new(get_comment_attributes)
        
        if @comment.save

            if params[:comment_id].present?

                @parent_object.increment_reply_count(params[:comment_id])
                
            elsif params[:subreddit_id].present?

                @parent_object.increment_reply_count(params[:subreddit_id])

            end

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

        params.require(:comment).permit(:comment, :commenter, :commentable_type, :commentable_id, :replies_count)

    end

end
