require "json"
require 'pry'

class DataParser

  attr_reader :path, :users, :data, :items

  def initialize path
    @path = path
    @users = []
    @data = JSON.parse(File.read path)
    @items = []
  end

  def parse!
    data["users"].each do |user|
      @users.push(User.new user.values[0],
                           user.values[1],
                           user.values[2])
    end
    data["items"].each do |item|
      @items.push(Item.new item.values[0],
                           item.values[1],
                           item.values[2],
                           item.values[3])
    end
  end

  def find_user_by_id user_id
    users.each do |u|
      if u.id == user_id
        return u.name
      end
    end
    return "User not found"
  end

  def find_item_id_by_name item_name
    items.each do |i|
      if i.name == item_name
        return i.id
      end
    end
    return "Item not found"
  end

  def find_item_ids item_name
    item_ids = []
    items.each do |i|
      if i.category.include? item_name
        item_ids.push(i.id)
      end
    end
    return item_ids
  end
end
