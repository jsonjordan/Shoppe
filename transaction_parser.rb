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
    # binding.pry
    data.each do |transa|
      @transaction.push(Transaction.new transa.values[0],
                                        transa.values[1],
                                        transa.values[2],
                                        transa.values[3])
    end
  end
end
