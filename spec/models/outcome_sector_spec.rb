 RSpec.describe OutcomeSector do
   describe "validations" do
     subject(:outcome_sector) { FactoryBot.build(:outcome_sector) }

     it "has a valid default factory" do
       expect(outcome_sector).to be_valid
     end
   end
 end
