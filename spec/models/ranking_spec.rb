RSpec.describe Ranking do
  before do
    sector_123 = FactoryBot.create(:sector, id: 123)
    sector_456 = FactoryBot.create(:sector, id: 456)

    FactoryBot.create(:company, name: "c",   sector: sector_456)
    FactoryBot.create(:company, name: "aa",  sector: sector_123)
    FactoryBot.create(:company, name: "bbb", sector: sector_123)
  end

  it "ranks scopes by an order clause" do
    ranking = described_class.new(Company.all, :name)

    expect(ranking.map(&:name)).to eq %w[aa bbb c]
    expect(ranking.map(&:rank)).to eq [1, 2, 3]
  end

  it "handles ties correctly" do
    ranking = described_class.new(Company.all, :sector_id)

    expect(ranking.map(&:sector_id)).to eq [123, 123, 456]
    expect(ranking.map(&:rank)).to eq [1, 1, 3]
  end

  it "handles complex order clauses" do
    ranking = described_class.new(Company.all, "length(name) desc")

    expect(ranking.map(&:name)).to eq %w[bbb aa c]
    expect(ranking.map(&:rank)).to eq [1, 2, 3]
  end
end
