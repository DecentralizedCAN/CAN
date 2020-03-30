module CommentsHelper
  def new_comment(content, discussion_id)

    if content.include?('+')
      tag = content.split('+')[1].split(' ')[0]
      @linked_user = User.find_by(name: tag)

      if @linked_user
        content = content.sub!("+#{tag}", "+<a href='/users/#{@linked_user.hashid}'>#{tag}</a>")
      end
    end

    @comment = Comment.new(:content => content, :discussion_id => discussion_id, :user_id => current_user.id)

    # respond_to do |format|
      if @comment.save

        begin
          auto_upvote_post(@comment.discussion.post.id, current_user.id)
        rescue
        end

        # Notifications
        if @linked_user
          notification = @linked_user.notification.create(:details => "You were mentioned in a comment", :discussion_id => @comment.discussion.id)
          
          if @linked_user.email_notifications
            notification.send_email
          end
        end

        # Notifications ends

      #   if @comment.discussion.problem
      #     format.html { redirect_to issue_path(@comment.discussion.problem.hashid, :anchor => "main-discussion") }
      #   elsif @comment.discussion.activity
      #     format.html { redirect_to action_path(@comment.discussion.activity.hashid, :anchor => "main-discussion") }
      #   elsif @comment.discussion.solution
      #     format.html { redirect_to solution_path(:problem_id => @comment.discussion.solution.problem.hashid, :solution_id => @comment.discussion.solution.hashid, :anchor => "main-discussion") }
      #   else
      #     format.html { redirect_to @comment.discussion }
      #     format.json { render :show, status: :created, location: @comment }
      #   end
      # else
      #   format.html { redirect_to @comment.discussion, notice: 'Comment invalid' }
      #   # format.html { render :new }
      #   # format.json { render json: @comment.errors, status: :unprocessable_entity }
      # end
    end

  end
end
