class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :require_login

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    content = params[:comment][:content]

    if content.include?('@')
      tag = content.split('@')[1].split(' ')[0]
      @linked_user = User.find_by(name: tag)

      if @linked_user
        content = content.sub!("@#{tag}", "@<a href='/users/#{@linked_user.hashid}'>#{tag}</a>")
      end
    end

    comment_params[:content] = content

    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save

        # Notifications
        if @linked_user
          notification = @linked_user.notification.create(:details => "You were mentioned in a comment", :discussion_id => @comment.discussion.id)
          notification.send_email
        end
        # Notifications ends

        if @comment.discussion.problem
          format.html { redirect_to issue_path(@comment.discussion.problem.hashid, :anchor => "main-discussion") }
        elsif @comment.discussion.activity
          format.html { redirect_to action_path(@comment.discussion.activity.hashid, :anchor => "main-discussion") }
        elsif @comment.discussion.solution
          format.html { redirect_to solution_path(@comment.discussion.solution.hashid, :anchor => "main-discussion") }
        else
          format.html { redirect_to @comment.discussion }
          format.json { render :show, status: :created, location: @comment }
        end
      else
        format.html { redirect_to @comment.discussion, notice: 'Comment invalid' }
        # format.html { render :new }
        # format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    if current_user.admin?
      @comment.destroy
      respond_to do |format|
        format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:content, :discussion_id, :user_id)
    end
end
