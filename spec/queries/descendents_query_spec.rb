RSpec.describe DescendentsQuery do
  subject(:query) { described_class.new(group) }

  let(:group) { FactoryBot.create(:group) }
  let(:child1) { FactoryBot.create(:group) }
  let(:child2) { FactoryBot.create(:group) }
  let(:grandchild) { FactoryBot.create(:outcome) }

  before do
    FactoryBot.create(:group_member, group: group, member: child1)
    FactoryBot.create(:group_member, group: group, member: child2)

    FactoryBot.create(:group_member, group: child1, member: grandchild)
    FactoryBot.create(:group_member, group: child2, member: grandchild)
  end

  it "returns a recursive list of parent/child relationships starting from the member" do
    results = query.execute

    expect(results).to match_array [
      { parent_type: "Group", parent_id: group.id, child_type: "Group", child_id: child1.id },
      { parent_type: "Group", parent_id: group.id, child_type: "Group", child_id: child2.id },

      { parent_type: "Group", parent_id: child1.id, child_type: "Outcome", child_id: grandchild.id },
      { parent_type: "Group", parent_id: child2.id, child_type: "Outcome", child_id: grandchild.id },
    ]
  end

  it "returns an empty list for members with no descendents" do
    query = described_class.new(grandchild)
    expect(query.execute).to be_empty

    query = described_class.new(FactoryBot.create(:company))
    expect(query.execute).to be_empty
  end

  it "does not mistake other objects for groups" do
    matches_group_id = FactoryBot.create(:company, id: group.id)

    query = described_class.new(matches_group_id)
    expect(query.execute).to be_empty
  end

  it "can optionally filter outcomes to a sector" do
    sector = FactoryBot.create(:outcome_sector, outcome: grandchild).sector
    another = FactoryBot.create(:sector)

    query = described_class.new(group, sector)
    expect(query.execute).to include(
      { parent_type: "Group", parent_id: child1.id, child_type: "Outcome", child_id: grandchild.id },
      { parent_type: "Group", parent_id: child2.id, child_type: "Outcome", child_id: grandchild.id },
    )

    query = described_class.new(group, another)
    expect(query.execute).not_to include(
      { parent_type: "Group", parent_id: child1.id, child_type: "Outcome", child_id: grandchild.id },
      { parent_type: "Group", parent_id: child2.id, child_type: "Outcome", child_id: grandchild.id },
    )
  end
end
