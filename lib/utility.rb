class Utility
  def self.is_integer?(value)
    /\A[-+]?\d+\z/ === value
  end
end