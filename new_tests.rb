require 'pry'
require 'minitest/autorun'
require 'minitest/focus'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require "./item"
require "./user"
require "./data_parser"
require "./transaction_parser"
require "./transaction"

class Minitest::Test
  # A little magic here, but this adds a `file_path` helper
  # function that is available in all of our test classes (how?)
  def file_path file_name
    File.expand_path "../data/#{file_name}.json", __FILE__
  end
end

class DataParserTests < Minitest::Test
  def test_can_parse_data
    p = DataParser.new file_path("data")
    assert p.path.end_with? "data/data.json"
    assert_equal [], p.users

    # recommendation: to parse the file, use something like
    # require "json"
    # JSON.parse(File.read path)
    p.parse!

    assert_equal 30, p.users.count
    assert_equal 20, p.items.count
    assert p.users.sample.is_a? User
    assert p.items.sample.is_a? Item
  end
end


class TransactionParserTests < Minitest::Test
  def test_can_parse_transactions
    p = TransactionParser.new file_path("transactions")
    p.parse!

    assert_equal 200, p.transaction.count
  end

  # Now it's your turn ... what other tests might be
  # helpful here? Feel free to re-use the existing test
  # files or to write your own
end
