require "set"

class Expenses
  attr_reader :input_file
  def initialize(input_file)
    @input_file = input_file
  end

  def expenses
    File.readlines(input_file, chomp: true).map(&:to_i).sort
  end

  def sum_of_two
    complements = Set.new

    expenses.each do |expense|
      if complements.include?(expense)
        break expense * complement_of(expense)
      else
        complements.add complement_of(expense)
      end
    end
  end

  # [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  #  i           j              k
  #
  #  example: trying to find sum to 17, set k to last index, set
  #  i to first index, set j to first index where i + j + k > 17.
  #  Then go into loop:
  #  if i == j
  #    decrease k, reset i to 1, find index for j, and call next
  #
  #  compare i + j + k to 17
  #  if too small, then increase i
  #  if too big then decrese j
  #  if equal then return i * j * k
  #
  def sum_of_three
    i = 0
    k = expenses.size - 1
    j = findex_j(i,k)

    while true
      if i == j
        k -= 1
        i = 0
        j = findex_j(i,k)
        next
      end

      case sum(i,j,k) <=> SUM
      when -1
        # too small
        i += 1
      when 1
        # too big
        j -= 1
      when 0
        # found match
        break mult(i,j,k)
      end
    end
  end

  private

  SUM = 2020

  def sum(i,j,k)
    expenses[i] + expenses[j] + expenses[k]
  end

  def mult(i,j,k)
    expenses[i] * expenses[j] * expenses[k]
  end

  # find index of first expense such that the sum is larger than SUM
  def findex_j(i,k)
   expenses.bsearch_index { |expense| (expense + expenses[i] + expenses[k] > SUM) }
  end

  def complement_of(expense)
    SUM - expense
  end
end
