require 'minitest/autorun'
require 'timeout'
require './lib/customer_success_balancing'

class CustomerSuccessBalancingTests < Minitest::Test
  def test_scenario_one
    balancer = CustomerSuccessBalancing.new(
      build_customer_success_scores([60, 20, 95, 75]),
      build_customer_scores([90, 20, 70, 40, 60, 10]),
      [2, 4]
    )
    assert_equal 1, balancer.execute
  end

  def test_scenario_two
    balancer = CustomerSuccessBalancing.new(
      build_customer_success_scores([11, 21, 31, 3, 4, 5]),
      build_customer_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      []
    )
    assert_equal 0, balancer.execute
  end

  def test_scenario_three
    balancer = CustomerSuccessBalancing.new(
      build_customer_success_scores(Array(1..999)),
      build_customer_scores(Array.new(10000, 998)),
      [999]
    )
    result = Timeout.timeout(1.0) { balancer.execute }
    assert_equal 998, result
  end

  def test_scenario_four
    balancer = CustomerSuccessBalancing.new(
      build_customer_success_scores([1, 2, 3, 4, 5, 6]),
      build_customer_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      []
    )
    assert_equal 0, balancer.execute
  end

  def test_scenario_five
    balancer = CustomerSuccessBalancing.new(
      build_customer_success_scores([100, 2, 3, 6, 4, 5]),
      build_customer_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      []
    )
    assert_equal 1, balancer.execute
  end

  def test_scenario_six
    balancer = CustomerSuccessBalancing.new(
      build_customer_success_scores([100, 99, 88, 3, 4, 5]),
      build_customer_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      [1, 3, 2]
    )
    assert_equal 0, balancer.execute
  end

  def test_scenario_seven
    balancer = CustomerSuccessBalancing.new(
      build_customer_success_scores([100, 99, 88, 3, 4, 5]),
      build_customer_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      [4, 5, 6]
    )
    assert_equal 3, balancer.execute
  end

  def test_scenario_eight
    balancer = CustomerSuccessBalancing.new(
      build_customer_success_scores([60, 40, 95, 75]),
      build_customer_scores([90, 70, 20, 40, 60, 10]),
      [2, 4]
    )
    assert_equal 1, balancer.execute
  end

  private

  ##
  # Separated score building for two main reasons:
  # 1. Customer scores being built with :unserved flag would be
  # a smart way to model data to help optimize the algorithm
  # 2. Customer and Customer Success would be two separate data models.
  # Assuming that, we face these "helper/mock" below methods as a fetch/select in our database.

  def build_customer_success_scores(scores)
    scores.map.with_index do |score, index|
      { id: index + 1, score: score }
    end
  end

  def build_customer_scores(scores)
    scores.map.with_index do |score, index|
      { id: index + 1, score: score, unserved: true }
    end
  end
end