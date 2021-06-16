class Hash
  def compact
    h = {}
    each do |key, value|
      h[key] = value unless value == nil
    end
    h
  end unless method_defined? :compact

  def compact!
    reject! {|_key, value| value == nil}
  end unless method_defined? :compact!

  def except(*keys)
    if keys.size > 4 && size > 4 # index if O(m*n) is big
      h = {}
      keys.each { |key| h[key] = true }
      keys = h
    end
    reject { |key, _value| keys.include? key}
  end unless method_defined? :except
end
