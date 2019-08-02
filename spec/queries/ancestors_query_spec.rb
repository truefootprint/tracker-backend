RSpec.describe AncestorsQuery do
  subject(:query) { described_class.new(outcome) }

  let(:grandparent) { FactoryBot.create(:group) }
  let(:parent1) { FactoryBot.create(:group) }
  let(:parent2) { FactoryBot.create(:group) }
  let(:outcome) { FactoryBot.create(:outcome) }

  before do
    FactoryBot.create(:group_member, group: grandparent, member: parent1)
    FactoryBot.create(:group_member, group: grandparent, member: parent2)

    FactoryBot.create(:group_member, group: parent1, member: outcome)
    FactoryBot.create(:group_member, group: parent2, member: outcome)
  end

  it "returns a recursive list of child/parent relationships starting from the member" do
    results = query.execute

    expect(results).to match_array [
      { child_type: "Outcome", child_id: outcome.id, parent_type: "Group", parent_id: parent1.id },
      { child_type: "Outcome", child_id: outcome.id, parent_type: "Group", parent_id: parent2.id },

      { child_type: "Group", child_id: parent1.id, parent_type: "Group", parent_id: grandparent.id },
      { child_type: "Group", child_id: parent2.id, parent_type: "Group", parent_id: grandparent.id },
    ]
  end

  it "returns an empty list for members with no ancestors" do
    query = described_class.new(grandparent)
    expect(query.execute).to be_empty

    query = described_class.new(FactoryBot.create(:company))
    expect(query.execute).to be_empty
  end
end
