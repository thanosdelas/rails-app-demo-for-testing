class ProductsController < ApplicationController

  def initialize
    super
    @page = "products"
  end

  def index

    @title = "Products Listing"

    # children_ids = ProductCategory.children_ids
    # return render plain: children_ids.inspect

    # Check if page exists in params or set to 1
    page = 1
    if params.has_key?(:page)
      page = params[:page].to_i
    end
    
    Product.filters(request.params)
    @pagination = Product.pagination(page)
    @products = Product.products
    @product_categories = ProductCategory.all()

  end

  def api
    @products = Product.all()
    # return render json: @products
    return self.json(@products)
  end

  def show
    @product = Product.find(params[:id])
    # return render plain: params[:id].inspect
  end

  def new
    @product = Product.new
    @product_categories = ProductCategory.all()
  end

  def create

    @product = Product.new(product_params)
    @product_categories = ProductCategory.all()

    if @product.save
      flash[:success] = "Product created"
      redirect_to @product
    else      
      render :new
      #render :json => { :errors => @article.errors.full_messages }
    end
  end

  def edit
    @product = Product.find(params[:id])
    @product_categories = ProductCategory.all()
  end

  def update

    @product = Product.find(params[:id])
    @product_categories = ProductCategory.all()

    if @product.update(product_params)
      redirect_to @product
    else
      render :edit
    end

  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    redirect_to products_path
  end

  def generate_products
    products = Product.all()
    products.destroy_all()

    #
    # Insert products from json
    #
    require 'json'
    products_file = File.read('./db/dummy-content/products.json')

    begin
      products = JSON.parse(products_file)
    rescue StandardError => e
      flash[:danger] = "Something went wrong while trying to parse json file: ./db/dummy-content/products.json <br /> #{e.to_s}"
      return redirect_to action: "index"
    end

    products["products"].each do |product_data|
      product = Product.new(
        "name": product_data["name"],
        "description": product_data["description"],
        "product_category_id": product_data["category_id"],
      )
      if !product.save()
        # return render plain: product.inspect
        flash[:danger] = "Could not generate product: "+
          +product["name"]+" "+
          +product.errors.messages.inspect+
          +product.errors.full_messages.inspect
        return redirect_to action: "index"
      end
    end

    #
    # Insert random products
    #
    20.times { |i| 

      product_name = "Product - #{i+1} "+(0...10).map { ('a'..'z').to_a[rand(26)] }.join
      product_description = "Description #{i} "+(0...100).map { ('a'..'z').to_a[rand(26)] }.join

      product = Product.new(
        "name": product_name,
        "description": product_description,
        "product_category_id": 100
      )

      if !product.save()
        flash[:danger] = "Could not generate products: "+
          +product.errors.messages.inspect+
          +product.errors.full_messages.inspect
        return redirect_to action: "index"
      end
    }

    return redirect_to action: "index"

  end

  private
    def product_params
      params.require(:product).permit(:name, :description, :product_category_id)
    end

end
