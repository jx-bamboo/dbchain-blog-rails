class ArticlesController < ApplicationController
  before_action :check_login, only: %i[ new create edit update destroy ]
  before_action :set_article, only: %i[ show edit update destroy ]

  # GET /articles or /articles.json
  def index
    if params[:search].present?
      @articles = Article.where("title like ?", ['%', params[:search], '%'].join).page(params[:page]).per(3)
    elsif params[:view].present?
      @articles = Article.order(view: :DESC).page(params[:page]).per(3)
    else
      @articles = Article.all.page(params[:page]).per(3)
    end
  end

  # GET /articles/1 or /articles/1.json
  def show
    @title = Article.pluck(:id,:title)
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)
    @article.user_id = current_user['id']
    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
      @article.update_columns(view: @article.view.to_i+1) if params[:action] == 'show'
    end

    # Only allow a list of trusted parameters through.
    def article_params
      # params.fetch(:article, {})
      params.require(:article).permit(:title,:content, :status, :user_id)
    end

    def check_login
      unless current_user
        redirect_to sign_up_path
      end
    end
end
