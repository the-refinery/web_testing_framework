class Hyperlink
  def initialize(href, target)
    @href = href
    @target = target
  end
  
  def to_s
    "Hyperlink(href: " + @href + ",target: " + @target + ")"
  end
  
  def href
    @href
  end
  
  def target
    @target
  end
  
  def equal?(link)
    (@href == link.href && @target == link.target)
  end
end