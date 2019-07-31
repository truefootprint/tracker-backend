class OutcomePresenter
  attr_accessor :outcome

  def initialize(outcome)
    self.outcome = outcome
  end

  def as_json(_options = {})
    { name: outcome.name }
  end
end
