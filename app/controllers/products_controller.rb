class ProductsController < ApplicationController

  def initialize
    super
    @page = "products"
  end

  def index

    @title = "Products Listing"
    # @products = Product.all()
    @pagination = {
      page: 1,
      per_page: 10,
      total: 0,
      pages: 0,
      offset: 0,
      showing: ""
    }

    # Check if page exists in params
    if params.has_key?(:page)
      @pagination[:page] = params[:page].to_i
    end

    # Calculate offset
    if @pagination[:page] > 1
      @pagination[:offset] = (@pagination[:page] - 1) * @pagination[:per_page]
    end

    @pagination[:total] = Product.all.count
    @pagination[:pages] = (Product.all.count / @pagination[:per_page].to_f).ceil
    # return render plain: @pagination[:pages].to_s

    @pagination[:showing] = @pagination[:offset].to_s+" - "+(@pagination[:offset]+@pagination[:per_page]).to_s

    @products = Product.order(created_at: :asc).limit(@pagination[:per_page]).offset(@pagination[:offset])
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
  end

  def create

    @product = Product.new(product_params)

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
  end

  def update

    @product = Product.find(params[:id])

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

    68.times { |i| 

      product_name = "Product - #{i+1} "+(0...10).map { ('a'..'z').to_a[rand(26)] }.join
      product_description = "Description #{i} "+(0...100).map { ('a'..'z').to_a[rand(26)] }.join

      product = Product.new("name": product_name, "description": product_description)
      if !product.save()
        flash[:danger] = "Could not generate products: "+product.errors.messages.inspect+product.errors.full_messages.inspect
        return redirect_to action: "index"
      end
    }

    return redirect_to action: "index"

  end

  private
    def product_params
      params.require(:product).permit(:name, :description)
    end

end
