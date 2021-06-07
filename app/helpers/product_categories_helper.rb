module ProductCategoriesHelper

	#
	# Print nested categories
	#
  def print_categories(categories)

  	@collect_html = '<ul class="nested-categories">'
  	categories = categories.as_json
		parse_poduct_categories_presentation(categories)
		@collect_html += "</ul>"

		return @collect_html.html_safe
  end

	#
	# Print nested categories options
	# To be wrapped in select tag
	# Use for create / update product categories
	#
  def print_categories_dropdown_options(categories, category)

  	@selected_category = category;
  	@collect_html = ''
  	categories = categories.as_json
		parse_categories_dropdown(categories)
		# You can set empty parent category to "null" or ""
		@collect_html = '<option value="null">-</option>'+@collect_html;
		return @collect_html.html_safe
  end

	#
	# Print nested categories options
	# To be wrapped in select tag
	# Use for create / update product	
	#
  def print_product_categories_dropdown_options(categories, product)
  	@collect_html = ''
    @selected_product_category = product
  	parse_categories_dropdown_for_product(categories)  	
  	return @collect_html.html_safe
  end

  private

	  #
	  # Parse categories hierachy for presentation
	  #
	  def parse_poduct_categories_presentation(categories, depth=-1, parent_id=nil)

	    depth += 1
	    nested_width = 12;
	    symbol = " * "
	    categories.each do |c|
	      if parent_id == c["parent_id"]
	        html = []

	        html.append('<li style="padding-left: '+(nested_width*(depth+1)).to_s+'px">')
		        html.append('<a href="'+product_category_path(c["id"])+'">')
			        html.append(symbol*depth)
			        html.append(c["name"])
	        	html.append('</a>')
	        html.append('</li>')

	        @collect_html += html.join("")
	        # collect_html += c["name"]

	        parse_poduct_categories_presentation(categories, depth, c["id"])
	      end
	    end

	  end

	  #
	  # Parse categories hierachy for dropdown select
	  #
	  def parse_categories_dropdown(categories, depth=-1, parent_id=nil)

	    depth += 1
	    nested_width = 12;
	    symbol = "-"
	    categories.each do |c|
	      if parent_id == c["parent_id"]
	        html = []

	        selected = ''
	        selected = 'selected' if c["id"] == @selected_category['parent_id']

	        html.append('<option style="padding-left: '+(nested_width*(depth+1)).to_s+'px" value="'+c["id"].to_s+'" '+selected+'>')
		        html.append(symbol*depth)
		        html.append(c["name"])
	        html.append('</option>')
	        @collect_html += html.join("")

	        parse_categories_dropdown(categories, depth, c["id"])
	      end
	    end

	  end

	  #
	  # Parse categories hierachy for products dropdown select
	  #
	  def parse_categories_dropdown_for_product(categories, depth=-1, parent_id=nil)

	    depth += 1
	    nested_width = 12;
	    symbol = "-"
	    categories.each do |c|
	      if parent_id == c["parent_id"]
	        html = []

	        selected = ''
	        selected = 'selected' if c["id"] == @selected_product_category['product_category_id']

	        html.append('<option style="padding-left: '+(nested_width*(depth+1)).to_s+'px" value="'+c["id"].to_s+'" '+selected+'>')
		        html.append(symbol*depth)
		        html.append(c["name"])
	        html.append('</option>')
	        @collect_html += html.join("")

	        parse_categories_dropdown_for_product(categories, depth, c["id"])
	      end
	    end

	  end

end