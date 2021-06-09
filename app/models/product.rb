class Product < ApplicationRecord

  validates :name, presence: true, length: { minimum: 5 }, uniqueness: true
  validates :description, presence: true, length: { minimum: 10 }
  belongs_to :product_category, class_name: 'ProductCategory', foreign_key: 'product_category_id', required: true

  def self.products

    if @pagination[:page] > 1
      @pagination[:offset] = (@pagination[:page] - 1) * @pagination[:per_page]
    end

    @pagination[:total] = Product.all.count
    @pagination[:pages] = (Product.all.count / @pagination[:per_page].to_f).ceil
    @pagination[:showing] = (@pagination[:offset]+1).to_s+" - "+(@pagination[:offset]+@pagination[:per_page]).to_s

    @products = select('products.*, product_categories.name as category_name')
      .order(created_at: :asc)
      .limit(@pagination[:per_page])
      .offset(@pagination[:offset])
      .joins(:product_category)
      # .where("product_categories.id=301")

    return @products
  end

  def self.pagination(page)

    @pagination = {
      page: page,
      per_page: 10,
      total: 0,
      pages: 0,
      offset: 0,
      showing: ""
    }

    return @pagination

  end

end
