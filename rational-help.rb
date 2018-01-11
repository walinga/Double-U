class RationalHelp
  def r2n(r)
    r.denominator == 1 ? r.to_i : r
  end

  # Make sure b is not a float when calling this
  def r_div(a,b)
    r2n(a / b.to_r)
  end 
end