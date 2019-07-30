class Rankingx
  include Enumerable

  attr_accessor :scope

  def initialize(scope, order)
    self.scope = rank(scope, order)
  end

  def each(&block)
    scope.each(&block)
  end

  private

  def rank(scope, order)
    scope.select("*, RANK() OVER(ORDER BY #{order})")
  end
end
