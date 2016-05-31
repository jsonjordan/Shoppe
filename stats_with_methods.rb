require "pry"
require "./item"
require "./user"
require "./data_parser"
require "./transaction_parser"
require "./transaction"

def file_path file_name
  File.expand_path "../data/#{file_name}.json", __FILE__
end

p = TransactionParser.new file_path("transactions")
b = DataParser.new file_path("data")
p.parse!
b.parse!

#* The user that made the most orders was __
puts "Problem 1: The user that made the most orders was __"

user_id = p.most_orders_by_user_id
most_orders_name = b.find_user_by_id(user_id)

puts "User with most orders: #{most_orders_name}"

#* We sold __ Ergonomic Rubber Lamps
puts
puts "Problem 2: We sold __ Ergonomic Rubber Lamps"

item_id = b.find_item_id_by_name("Ergonomic Rubber Lamp")
items_sold = p.find_quantity_sold_by_item_id(item_id)

puts "We sold #{items_sold} Ergonomic Rubber Lamps"

#* We sold __ items from the Tools category
puts
puts "Problem 3: We sold __ items from the Tools category"

all_item_ids = b.find_item_ids("Tools")
tools_sold = p.find_quantity_sold_by_multiple_ids(all_item_ids)

puts "We sold #{tools_sold} items from the Tools category"
# tool_ids = []
# b.items.each do |i|
#   if i.category.include? "Tools"
#     tool_ids.push(i.id)
#   end
# end
# puts "#{tool_ids.count} items are part of the tool catagory"
#
# tools_sold = 0
# p.transaction.each do |t|
#   if tool_ids.include? t.item_id
#     tools_sold += t.quantity
#   end
# end
# puts "We sold #{tools_sold} items from the Tools category"
#
