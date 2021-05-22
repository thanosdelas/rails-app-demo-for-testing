class ProductCategoriesController < ApplicationController

  def initialize
    super
    @page = "product_categories"
  end

  def index
    @title = "Product Categories"
    @product_categories = ProductCategory.all()
  end

  def api
    @product_categories = Product.all()
    # return render json: @product_categories
    return self.json(@product_categories)
  end

  def show
    @product_category = ProductCategory.find(params[:id])
    # return render plain: params[:id].inspect
  end

  def new
    @product_category = ProductCategory.new
  end

  def create

    @product_category = ProductCategory.new(product_category_params)

    # @product_category[:parent_id] = nil
    # return render plain: @product_category.inspect

    if @product_category.save
      flash[:success] = "Product category created"
      redirect_to @product_category
    else      
      render :new
      #render :json => { :errors => @article.errors.full_messages }
    end
  end

  def edit
    @product_category = ProductCategory.find(params[:id])
  end

  def update

    @product_category = ProductCategory.find(params[:id])

    if @product_category.update(product_category_params)
      redirect_to @product_category
    else
      render :edit
    end

  end

  def destroy
    @product_category = ProductCategory.find(params[:id])
    @product_category.destroy

    redirect_to product_categories_path
  end

  def generate_categories

    product_categories = ProductCategory.all()
    product_categories.destroy_all()

    require 'json'
    product_categories_file = File.read('./db/dummy-content/product-categories.json')
    product_categories = JSON.parse(product_categories_file)
    product_categories["product_categories"].each do |product_category|
      category = ProductCategory.new(
        "id": product_category["product_category_id"], 
        "name": product_category["name"],
        "parent_id": product_category["parent_product_category_id"],
      )
      if !category.save()
        flash[:danger] = "Could not generate product category: "+category.errors.messages.inspect+category.errors.full_messages.inspect
        redirect_to action: "index"
      end
    end

    flash[:message] = "Product categories generated successfully"
    return redirect_to action: "index"
  end

  private
    def product_category_params
      params.require(:product_category).permit(:name, :parent_id)
    end

end
