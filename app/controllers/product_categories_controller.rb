class ProductCategoriesController < ApplicationController

  include ProductCategoriesHelper

  def initialize
    super
    @page = "product_categories"
  end

  def index
    @title = "Product Categories"
    @product_categories = ProductCategory.all()
    @product_categories_to_html = []
    @product_categories_parse = []

    @product_categories_nested = parse_categories(@product_categories)

    # return render plain: @product_categories_to_html.inspect
    # return parse_categories(@product_categories)
  end

  #
  # Dispatch parse categories
  #
  def parse_categories(categories)

    # Conert active record categories to json
    categories = @product_categories.as_json

    # parse_poduct_categories_presentation(categories, nil)
    return parse_poduct_categories(categories)
    # return render plain: parse_poduct_categories(categories)
    # return render json: @product_categories_parse.to_json

    # o = []
    # o.append("Parse categories <br />")
    # o.append(categories)
    # o.append(@product_categories_to_html)
    # o.append(@product_categories_parse)
    # o.append(@product_categories_parse.inspect)
    # return render inline: o.join("<br />")
  end

  #
  # Parse categories hierachy for presentation
  #
  def parse_poduct_categories_presentation(categories, selected_id=nil, depth=-1, parent_id=nil)

    depth += 1
    symbol = "--"
    categories.each do |c|
      if parent_id == c["parent_id"]
        html = []
        html.append(symbol*depth)
        html.append(c["name"])
        @product_categories_to_html.append(html.join(""))
        parse_poduct_categories_presentation(categories, selected_id, depth, c["id"])
      end
    end
  end

  #
  # Parse categories hierachy
  #
  def parse_poduct_categories(categories, result = [], depth=-1, parent_id=nil)

    depth += 1
    categories.each do |c|
      if parent_id == c["parent_id"]

        c["children"] = []
        result.append(c)
        parse_poduct_categories(categories, c["children"], depth, c["id"])
      end
    end

    return result

  end

  def api
    @product_categories = ProductCategory.all()
    return self.json(parse_categories(@product_categories))
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

    begin
      product_categories = JSON.parse(product_categories_file)
    rescue StandardError => e
      flash[:danger] = "Something went wrong while trying to parse json file: ./db/dummy-content/product-categories.json <br /> #{e.to_s}"
      return redirect_to action: "index"
    end

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
