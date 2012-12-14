require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'active_record'

url = "http://www.simplyrecipes.com/index/"
doc = Nokogiri::HTML(open(url))

$recipe = Array.new

=begin
doc.xpath('//*[contains(concat( " ", @class, " " ), concat( " ", "entry-content", " " ))]//p/a').each do |node|
  recipe = node.content.to_a
	puts recipe
end
=end

doc.xpath('//*[contains(concat( " ", @class, " " ), concat( " ", "entry-content", " " ))]//p/a')

doc.css('div > p > a').each do |node|
    $recipe << node.content
end

#puts "#{$recipe}"


=begin
$i=0
while $i<5 do
$val=$recipe.at($i)
	puts (" #{$val}")
$i +=1
end
=end

#database handling

ActiveRecord::Base.establish_connection(
:adapter => "mysql2",
:host => "localhost",
:database => "recipedb",
:username => "root",
:password => "webonise6186"
)

class Rubyist < ActiveRecord::Base
end

$j=0
while $j<700 do
$val=$recipe.at($j)
Rubyist.create(:rname =>$val)
$j +=1
end

participant = Rubyist.find(:first)

#puts {{participant.rname}}
