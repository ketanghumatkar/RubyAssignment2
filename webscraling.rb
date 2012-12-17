require 'nokogiri'
require 'open-uri'
require 'rubygems'
require 'active_record'

#constants
base_url="http://www.simplyrecipes.com/"
index_url="#{base_url}/index"

#connection to database
ActiveRecord::Base.establish_connection(
:adapter => "mysql2",
:host => "localhost",
:database => "recipedb",
:username => "root",
:password => "webonise6186"
)
#class
class Categary < ActiveRecord::Base
end

class Recipe < ActiveRecord::Base
end
#nokogiri doc fetching
index_doc=Nokogiri::HTML(open(index_url))
#puts index_doc
index_doc.xpath('//p/a').each_with_index do |catagary, cat_index|
	catagary_name=catagary.content
	#puts catagary_name
	catagary_url=catagary['href']
	#puts catagary_url
	
	#inserting row into category table
	Categary.create(:cid => cat_index,:cname => catagary_name,:curl => catagary_url)	

	catagary_page=Nokogiri::HTML(open(catagary_url))
		#puts catagary_page
		catagary_page.xpath('//h2/a').each_with_index do |recipe, rec_index|
			
			recipe_name=recipe.content
			#puts recipe;
			recipe_url=recipe['href'].to_s()

				recipe_page=Nokogiri::HTML(open(recipe_url))
					
					#coping recipe image url
					recipe_image_url=recipe_page.xpath('//div[@class="entry-content"]/div[@class="featured-image"]/img/@src')
					#puts recipe_image;
					#recipe_image_url=recipe_image['src']
					#coping description
					recipe_description=recipe_page.xpath('//div[@class="entry-content"]/div[@itemprop="description"]').to_s()
					#coping ingredient
					recipe_ingredient=Array.new
					recipe_page.xpath('//div[@id="recipe-ingredients"]/ul/li[@class="ingredient"]').each do |ingredient_value|
						recipe_ingredient.push(ingredient_value.content)
					end	
						recipe_ingredient.to_s()
					#coping method
					recipe_method_one=recipe_page.xpath('//div[@id="recipe-method"]/div[@itemprop="recipeInstructions"]').to_s()
					recipe_method_two=recipe_page.xpath('//div[@id="recipe-method"]/span[@class="yield"]').to_s()
					recipe_method=recipe_method_one + recipe_method_two
				
					#inserting row into recipe table
					Recipe.create(:cid => cat_index,:rid => rec_index,:rname => recipe_name,:rurl => recipe_url,:riurl => recipe_image_url,:rdesc => recipe_description,:ringredient => recipe_ingredient,:rmethod => recipe_method)
					
					#
					#if(rec_index==50)
					#	break 
					#end
					
		end#end catagory loop
			if(cat_index==50)
				break 
			end	
end#end index_doc loop
