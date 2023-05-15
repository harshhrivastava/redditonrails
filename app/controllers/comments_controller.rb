class CommentsController < ApplicationController

    before_action :authenticate_user!, except: [:index, :show]

    before_action :refresh

    def show

        if params[:comment_id]

            @comment = Comment.find(params[:comment_id])

            @page_number = params[:page].to_i

            @id = params[:comment_id]

        elsif params[:id]

            @comment = Comment.find(params[:id])

            @id = params[:id]

        end

        @replies = Comment.where({commentable_id: @comment[:id], commentable_type: "Comment"})

        if @comment[:commentable_type] == "Subreddit"

            @parent_object = Subreddit.find(@comment[:commentable_id])

        elsif @comment[:commentable_type] == "Comment"

            @parent_object = Comment.find(@comment[:commentable_id])

        end

        all_other_comments = @parent_object.comments

        unless params[:page].present?
        
            index = all_other_comments.find_index(@comment)

            @page_number = index / 5

        end

        start_index = @page_number * 5

        end_index = start_index + 4

        @other_comments = all_other_comments[start_index..end_index]

        @total_pages = all_other_comments.size / 5

        if @page_number > @total_pages

            render :json => ({error: ["Index out of bound. Last index is " + @total_pages.to_s]})

        else

            render :json => ({comment: @comment, id: @id, replies: @replies, comment_path: @comment.path[0..-2], other_comments: @other_comments, page_number: @page_number + 1, total_pages: @total_pages + 1})

        end

    end

    def new

        if params[:comment_id].present?

            @parent_object = Comment.find(params[:comment_id])

        else

            @parent_object = Subreddit.find(params[:subreddit_id])

        end

        @comment = @parent_object.comments.build

        @commenter = current_user[:fname]

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

        @comment[:user_id] = current_user[:id]
        
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
