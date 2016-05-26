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

user_orders = {}
user_orders.default = 0
p.transaction.each do |t|
  user_orders[t.user_id] = (user_orders[t.user_id] + 1)
end

def largest_hash_key(hash)
  hash.max_by{|k,v| v}
end

most_orders = largest_hash_key(user_orders)
puts "User with most orders: #{most_orders.first}"
puts "They had #{most_orders.last} orders"

#* We sold __ Ergonomic Rubber Lamps
puts
puts "Problem 2: We sold __ Ergonomic Rubber Lamps"

erl_id = 0
b.items.each do |i|
  if i.name == "Ergonomic Rubber Lamp"
    erl_id = i.id
  end
end
puts "The Ergonomic Rubber Lamps id number is #{erl_id}"

erls_sold = 0
p.transaction.each do |t|
  if t.item_id == erl_id
    erls_sold += t.quantity
  end
end
puts "We sold #{erls_sold} Ergonomic Rubber Lamps"

#* We sold __ items from the Tools category
puts
puts "Problem 3: We sold __ items from the Tools category"

tool_ids = []
b.items.each do |i|
  if i.category.include? "Tools"
    tool_ids.push(i.id)
  end
end
puts "Items in the tool catagory are #{tool_ids}"

tools_sold = 0
p.transaction.each do |t|
  if tool_ids.include? t.item_id
    tools_sold += t.quantity
  end
end
puts "We sold #{tools_sold} items from the Tools category"

#* Our total revenue was __
puts
puts "Problem 4: * Our total revenue was __"

items_by_quantity = {}
p.transaction.each do |t|
  items_by_quantity[t.item_id] = t.quantity
end

items_by_price = {}
b.items.each do |i|
  items_by_price[i.id] = i.price
end

total_revenue = 0
items_by_quantity.each do |qkey,qvalue|
  if !items_by_price[qkey].nil?
    total_revenue += (qvalue * items_by_price[qkey])
  end
end
puts "Our total revenue was $#{total_revenue}"
