module ProductCategoriesHelper

  def test_helper(categories)
  	# "Test inside ProductCategoryHelper: "+categories.inspect

  	# result = []
  	# categories.each do |category|
  	# 	result.append(category["name"])
  	# 	result.append("<hr />")
  	# end

  	# return result.join("<br />").html_safe

  	@collect_html = '<ul class="nested-categories">'
  	categories = categories.as_json
		parse_poduct_categories_presentation(categories)
		@collect_html += "</ul>"

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

	    # return collect_html

	  end

end