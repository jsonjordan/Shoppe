require "pry"
require "./item"
require "./user"
require "./data_parser"
require "./transaction_parser"
require "./transaction"

def file_path file_name
  File.expand_path "../data/#{file_name}.json", __FILE__
end

#* The user that made the most orders was __
p = TransactionParser.new file_path("transactions")
p.parse!

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
