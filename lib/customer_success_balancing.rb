class CustomerSuccessBalancing
  def initialize(customer_success, customers, away_customer_success)
    @customer_success = customer_success
    @customers = customers
    @away_customer_success = away_customer_success
  end

  # Returns the ID of the customer success with most customers
  def execute
    balanced_customer_success = []

    present_customer_success.each do |cs|
      balanced = {id: cs[:id], customer_count: 0}

      @customers.each do |c|
        next if cs[:score] < c[:score]

        next unless c[:unserved] 

        balanced[:customer_count] += 1
        c[:unserved] = false
      end

      balanced_customer_success.push(balanced)
    end

    return 0 if all_unserved?

    @balanced_customer_success = balanced_customer_success.sort_by { |bcs| bcs[:customer_count] }

    return 0 if draw?

    @balanced_customer_success.last[:id]
  end

  private

  ##
  # Select/filter only the present Customer Success
  # and order by its score to optimize the algorithm
  def present_customer_success
    @customer_success
      .reject { |cs| @away_customer_success.include?(cs[:id]) }
      .sort_by { |cs| cs[:score] }
  end

  ##
  # Helper method to check if all customers remain unserved
  def all_unserved?
    @customers.all? { |c| c[:unserved] }
  end

  ##
  # Check if the highest customer success served customers count
  # is equal to the next to last. In that case, it's considered a draw.
  def draw?
    @balanced_customer_success.last[:customer_count] === @balanced_customer_success[-2][:customer_count]
  end
end