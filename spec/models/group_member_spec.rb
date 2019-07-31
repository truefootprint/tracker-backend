RSpec.describe GroupMember do
  describe "validations" do
    subject(:group_member) { FactoryBot.build(:group_member) }

    it "has a valid default factory" do
      expect(group_member).to be_valid
    end

    it "requires a group" do
      group_member.group = nil
      expect(group_member).to be_invalid
    end

    it "requires a member" do
      group_member.member = nil
      expect(group_member).to be_invalid
    end

    it "requires that group/member is unique" do
      group = FactoryBot.create(:group)
      outcome = FactoryBot.create(:outcome)

      FactoryBot.create(:group_member, group: group, member: outcome)

      group_member.group = group
      group_member.member = outcome

      expect(group_member).to be_invalid
    end
  end
end
