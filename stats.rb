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

user_by_orders = {}
user_by_orders.default = 0
p.transaction.each do |t|
  user_by_orders[t.user_id] += 1
end

most_orders_name = ""
most_orders = user_by_orders.max_by{|key,value| value}

b.users.each do |u|
  if u.id == most_orders.first
    most_orders_name = u.name
  end
end
puts "User with most orders: #{most_orders_name}"
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
puts "#{tool_ids.count} items are part of the tool catagory"

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

quantity_per_item = {}
quantity_per_item.default = 0
p.transaction.each do |t|
  quantity_per_item[t.item_id] += t.quantity
end

price_per_item = {}
b.items.each do |i|
  price_per_item[i.id] = i.price
end

total_revenue = 0
quantity_per_item.each do |id,quant|
  if !price_per_item[id].nil?
    total_revenue += (quant * price_per_item[id])
  end
end
puts "Our total revenue was $#{total_revenue}"

#* Harder: the highest grossing category was __
puts
puts "Problem 5: The highest grossing category was __"

ids_by_category = {"Tools" => [], "Health" => [], "Electronics" => [], "Kids" => [],
                  "Computers" => [], "Jewelery" => [], "Games" => [], "Books" => [],
                  "Garden" => [], "Movies" => [], "Music" => [], "Beauty" => [],
                  "Industrial" => [],"Automotive" => [], "Sports" => [], "Outdoors" => [],
                  "Clothing" => []}

# categories = []
# b.items.each do |i|
#   categories.push (i.category.split(" & "))
# end
# categories = categories.flatten.uniq
#
# ids_by_category2 = {}
# categories.each do |cate|
#  ids_by_category2[cate] = []
# end

b.items.each do |i|
  ids_by_category.each do |cate,ids|
    if i.category.include? cate
      ids.push i.id
    end
  end
end

revenue_by_item = {}
quantity_per_item.each do |q_id, quant|
  price_per_item.each do |p_id, price|
    if q_id == p_id
      revenue_by_item[q_id] = (quant*price)
    end
  end
end

revenue_by_category = {}
revenue_by_category.default = 0
ids_by_category.each do |cate, c_ids|
  revenue_by_item.each do |r_id, rev|
    if c_ids.include? r_id
      revenue_by_category[cate] += rev
      revenue_by_category[cate] = revenue_by_category[cate].round(2)
    end
  end
end

most_rev_by_category = revenue_by_category.max_by {|key,value| value}
puts "#{most_rev_by_category.first} was the most profitable category, bringing in $#{most_rev_by_category.last}"
