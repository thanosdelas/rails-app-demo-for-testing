class ArticlesController < ApplicationController

  def initialize
    super
    @page = "articles"
  end  

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
    # return render plain: params[:article].inspect
  end

  def new
    @article = Article.new
  end

  def create
    # return render plain: params[:article].inspect
    @article = Article.new(article_params)    

    if @article.save      
      redirect_to @article
    else      
      render :new
      #render :json => { :errors => @article.errors.full_messages }
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render :edit
    end
  end

  private
    def article_params
      params.require(:article).permit(:title, :body)
    end

end
