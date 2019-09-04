class ComparisonPresenter
  attr_accessor :scope

  def initialize(scope)
    self.scope = scope
  end

  def as_json(_options = {})
    raise scope.to_a.inspect
  end
end
