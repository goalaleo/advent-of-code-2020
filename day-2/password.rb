class PasswordPolicy
  attr_reader :digit1, :digit2, :letter
  def initialize(digit1, digit2, letter)
    @digit1 = digit1
    @digit2 = digit2
    @letter = letter
  end

  def valid?(password)
    raise "Abstract method called, subclasses should override this"
  end
end

class SledShopPolicy < PasswordPolicy
  alias_method :min, :digit1
  alias_method :max, :digit2

  def valid?(password)
    (min..max).cover? password.count(letter)
  end
end

class ToboccanPolicy < PasswordPolicy
  alias_method :index1, :digit1
  alias_method :index2, :digit2

  def valid?(password)
    [index1, index2].count { |i| password[i-1] == letter } == 1
  end
end

class Password
  attr_reader :min, :max, :letter, :password, :policy
  def self.valid?(raw_password, policy)
    new(raw_password, policy).valid?
  end

  def initialize(raw_password, policy)
    min_max, letter_part, @password = raw_password.split
    @min, @max = min_max.split("-").map(&:to_i)
    @letter = letter_part[0]
    @policy = policy.new(min, max, letter)
  end

  def valid?
    policy.valid?(password)
  end
end
