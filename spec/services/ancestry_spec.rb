RSpec.describe Ancestry do
  let(:a) { FactoryBot.create(:group) }
  let(:b) { FactoryBot.create(:group) }
  let(:c) { FactoryBot.create(:group) }
  let(:d) { FactoryBot.create(:group) }
  let(:e) { FactoryBot.create(:group) }
  let(:f) { FactoryBot.create(:group) }
  let(:g) { FactoryBot.create(:group) }
  let(:h) { FactoryBot.create(:group) }

  let(:i) { FactoryBot.create(:outcome) }
  let(:j) { FactoryBot.create(:outcome) }

  before do
    # This setup constructs the following graph:
    #
    #       a   b   c
    #        \ /   /
    #         d   e
    #          \ /
    #           f
    #          / \
    #         g   h
    #            / \
    #           i   j

    edges = [[a, d], [b, d], [c, e], [d, f], [e, f], [f, g], [f, h], [h, i], [h, j]]

    edges.each { |g, m| FactoryBot.create(:group_member, group: g, member: m) }
  end

  subject(:ancestry) { described_class.new(f) }

  it "has the expected parents" do
    expect(ancestry.parents).to match_array [
      { type: "Group", id: d.id },
      { type: "Group", id: e.id },
    ]
  end

  it "has the expected ancestors" do
    expect(ancestry.ancestors).to match_array [
      { type: "Group", id: d.id, ancestors: [
        { type: "Group", id: a.id, ancestors: [] },
        { type: "Group", id: b.id, ancestors: [] },
      ] },

      { type: "Group", id: e.id, ancestors: [
        { type: "Group", id: c.id, ancestors: [] },
      ] },
    ]
  end

  it "has the expected children" do
    expect(ancestry.children).to match_array [
      { type: "Group", id: g.id },
      { type: "Group", id: h.id },
    ]
  end

  it "has the expected descendents" do
    expect(ancestry.descendents).to match_array [
      { type: "Group", id: g.id, descendents: [] },

      { type: "Group", id: h.id, descendents: [
        { type: "Outcome", id: i.id, descendents: [] },
        { type: "Outcome", id: j.id, descendents: [] },
      ] },
    ]
  end

  it "keeps track of which members have been seen" do
    expect(ancestry.seen).to match_array [
      { type: "Group", id: f.id },
    ]

    ancestry.parents
    expect(ancestry.seen).to match_array [
      { type: "Group", id: d.id },
      { type: "Group", id: e.id },
      { type: "Group", id: f.id },
    ]

    ancestry.descendents
    expect(ancestry.seen).to match_array [
      { type: "Group", id: d.id },
      { type: "Group", id: e.id },
      { type: "Group", id: f.id },
      { type: "Group", id: g.id },
      { type: "Group", id: h.id },
      { type: "Outcome", id: i.id },
      { type: "Outcome", id: j.id },
    ]
  end
end
