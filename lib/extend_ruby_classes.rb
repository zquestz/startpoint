class Hash
  # Filter keys out of a Hash.
  #   { :a => 1, :b => 2, :c => 3 }.except(:a)
  #   => { :b => 2, :c => 3 }
  def except(*keys)
    self.reject { |k,v| keys.include?(k || k.to_sym) }
  end

  # Override some keys.
  #   { :a => 1, :b => 2, :c => 3 }.with(:a => 4)
  #   => { :a => 4, :b => 2, :c => 3 }
  def with(overrides = {})
    self.merge overrides
  end

  # Returns a Hash with only the pairs identified by +keys+.
  #   { :a => 1, :b => 2, :c => 3 }.only(:a)
  #   => { :a => 1 }
  def only(*keys)
    self.reject { |k,v| !keys.include?(k || k.to_sym) }
  end

  # Recursively merges 2 hashes. By default Ruby has a shallow merge.
  #  { :a => { :a => 1, :b => 1 } }.recursive_merge({ :a => { :b => 2 } })
  #  => { :a => { :a => 1, :b => 2 } }
  def recursive_merge(other)
    hash = self.dup
    other.each do |key, value|
      myval = self[key]
      if value.is_a?(Hash) && myval.is_a?(Hash)
        hash[key] = myval.recursive_merge(value)
      else
        hash[key] = value
      end
    end
    hash
  end
end