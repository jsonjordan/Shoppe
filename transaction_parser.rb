require "json"
require 'pry'

class TransactionParser

  attr_reader :path, :data, :transaction

  def initialize path
    @path = path
    @data = JSON.parse(File.read path)
    @transaction = []
  end

  def parse!
    data.each do |transa|
      @transaction.push(Transaction.new transa.values[0],
                                        transa.values[1],
                                        transa.values[2],
                                        transa.values[3])
    end
  end

  def find_orders_by_user
    orders_by_user = {}
    orders_by_user.default = 0
    transaction.each do |t|
      orders_by_user[t.user_id] += 1
    end
    orders_by_user
  end

  def most_orders_by_user_id
    (find_orders_by_user.max_by{|key,value| value}).first
  end

  def find_quantity_sold_by_item_id item_id
    items_sold = 0
    transaction.each do |t|
      if t.item_id == item_id
        items_sold += t.quantity
      end
    end
    return items_sold
  end

  def find_quantity_sold_by_multiple_ids ids_array
    total_items_sold = 0
    ids_array.each do |id|
      total_items_sold += find_quantity_sold_by_item_id
    end
    total_items_sold
  end

end
