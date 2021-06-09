class Product < ApplicationRecord

  validates :name, presence: true, length: { minimum: 5 }, uniqueness: true
  validates :description, presence: true, length: { minimum: 10 }
  belongs_to :product_category, class_name: 'ProductCategory', foreign_key: 'product_category_id', required: true

  NULL_ATTRS = %w( product_category_id )

  before_save :blank_product_category_id

  def self.products

    if @pagination[:page] > 1
      @pagination[:offset] = (@pagination[:page] - 1) * @pagination[:per_page]
    end    

    @products = select('products.*, product_categories.name as category_name')
      .order(created_at: :asc)
      .limit(@pagination[:per_page])
      .offset(@pagination[:offset])
      .joins(:product_category)
    
    #
    # You should find a more elegant way to calculate total results with filters
    # see: https://stackoverflow.com/questions/14227761/how-to-select-data-for-defined-page-and-total-count-of-records
    # @pagination[:total] = @products.except(:offset, :limit).count
    #
    total = Product.select("*").joins(:product_category)

    if @filters.key?("product_name")
      total = total.where("products.name like ?", "%"+@filters["product_name"]+"%")
      @products = @products.where("products.name like ?", "%"+@filters["product_name"]+"%")
    end

    if @filters.key?("product_category_id") && @filters["product_category_id"] != '-'
      @products = @products.where(product_category_id: ProductCategory.children_ids(@filters[:product_category_id]))
      total = total.where(product_category_id: ProductCategory.children_ids(@filters[:product_category_id]))
    end

    @pagination[:total] = total.count
    @pagination[:pages] = (total.count / @pagination[:per_page].to_f).ceil

    @pagination[:showing] = (@pagination[:offset]+1).to_s+" - "+(@pagination[:offset]+@pagination[:per_page]).to_s
    if total.count < @pagination[:per_page]
      @pagination[:showing] = total.count
    end

    return @products
  end

  def self.filters(filters)

    @filters = filters
    return @filters

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

  protected

    def blank_product_category_id
      NULL_ATTRS.each { |attr| self[attr] = nil if self[attr].blank? || self[attr]==0 }
    end

end
