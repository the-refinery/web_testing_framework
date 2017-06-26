class Hyperlink
  def initialize(href, target)
    @href = href
    @target = target
  end
  
  def to_s
    "Hyperlink(href: " + @href + ",target: " + @target + ")"
  end
end