class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy ]
  before_action :logged_in, except: %i[ login check new create]
  before_action :is_current_user, only: %i[ show edit update destroy]


  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def login
    @user = User.new
    session[:user_id] = nil
  end

  def check
    @commit = params[:commit]
    @umail = params[:user][:email]
    @upass = params[:user][:password]
    if(@commit == 'Login')
      @found = false
      @u = User.find_by(email:@umail)
      if(@u && @u.authenticate(@upass))
          redirect_to feed_path, notice: "Login successfully."
          @found = true
          session[:user_id] = @u.id
      end
      if(@found == false)
        redirect_to main_path, alert: "Incorrect Email or Password."
      end
    elsif(@commit == 'Register')
      redirect_to new_user_path
    end
  end



  def feed
    @user = User.find(session[:user_id])  
    @feedpost = @user.get_feed_post

  end


  def viewUser
    @name = params[:name]
    @user = User.find_by(name:@name)
    if(@user == nil)
      redirect_to feed_path, alert: "User not found."
    end
  end

  def manageFollow
    @commit = params[:commit]
    @follower_id = session[:user_id]
    @followee_id = params[:follow][:followee_id]
    if(@commit == 'Follow')
      f = Follow.create(:follower_id => @follower_id, :followee_id => @followee_id)
    end
    if(@commit == 'Unfollow')
      Follow.find_by(follower_id: @follower_id, followee: @followee_id).destroy
    end
    redirect_back(fallback_location: "profile/:name")
  end

  def like
    @pid = params[:pid]
    Like.create(post_id: @pid, likeUser: session[:user_id])
    redirect_to feed_path, notice: "liked"


  end

  def unlike
    @pid = params[:pid]
    Like.find_by(post_id: @pid,likeUser: session[:user_id]).destroy
    redirect_back(fallback_location: "feed")

  end

  private
    def logged_in
      if(session[:user_id])
       return true
      else
       redirect_to main_path, alert: "Please Login"
      end
    end

    def is_current_user
      if(session[:user_id].to_s == params[:id])
        return true
      else
        redirect_to feed_path, alert: "You can't view/edit/destroy other users account"
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
