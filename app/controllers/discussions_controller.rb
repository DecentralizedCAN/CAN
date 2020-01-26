class DiscussionsController < ApplicationController
  before_action :set_discussion, only: [:show, :edit, :update]
  before_action :check_activity, only: [:create]
  before_action :require_login, except: [:show], if: -> { public_viewable? }
  before_action :require_login, unless: -> { public_viewable? }
  before_action :require_admin_or_anarchy, only: [:new, :create]

  # GET /discussions
  # GET /discussions.json
  def index
    @discussions = Discussion.all
  end

  # GET /discussions/1
  # GET /discussions/1.json
  def show
    @comment = @discussion.comment.new

    @recent_liked = @discussion.comment.left_joins(:upvotes)
        .group(:id)
        .order("COUNT(upvotes.id) / (extract(epoch from now()) - extract(epoch from comments.created_at)) DESC LIMIT 8")
        .where("upvotes.id is not null")
      
        # .order("COUNT(upvotes.id) / (julianday('now')-julianday(comments.created_at)) DESC LIMIT 15") #probably won't work in postgres
    @top_liked = @discussion.comment.left_joins(:upvotes)
        .group(:id)
        .order("COUNT(upvotes.id) DESC LIMIT 8")
        .where("upvotes.id is not null")
      
  end

  # GET /discussions/new
  def new
    @discussion = Discussion.new
  end

  # GET /discussions/1/edit
  def edit
  end

  # POST /discussions
  # POST /discussions.json
  def create
    @discussion = Discussion.new(discussion_params)
    @discussion.creator = current_user.name

    respond_to do |format|
      if @discussion.save

        # create post and upvote
        @post = Post.create(:discussion => @discussion)
        @post.upvotes.create(user_id: current_user.id)

        # keep record of user activity
        current_user.update(:last_posted => Time.now)

        format.html { redirect_to @discussion }
        format.json { render :show, status: :created, location: @discussion }
      else
        format.html { render :new }
        format.json { render json: @discussion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /discussions/1
  # PATCH/PUT /discussions/1.json
  def update
    respond_to do |format|
      if @discussion.update(discussion_params)
        format.html { redirect_to @discussion, notice: 'Discussion was successfully updated.' }
        format.json { render :show, status: :ok, location: @discussion }
      else
        format.html { render :edit }
        format.json { render json: @discussion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discussions/1
  # DELETE /discussions/1.json
  def destroy
    if current_user.admin?
      @discussion = Discussion.find(params[:id])
      @discussion.destroy
      respond_to do |format|
        format.html { redirect_to root_url, notice: 'Discussion was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_discussion
      @discussion = Discussion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def discussion_params
      params.require(:discussion).permit(:title, :content, :problem_id)
    end

    def public_viewable?
      Setting.find(6).state
    end
end
