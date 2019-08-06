mining = Sector.create!(name: "Mining")
auditing = Sector.create!(name: "Auditing")

glencore = Company.create!(name: "Glencore", sector: mining)
bhp = Company.create(name: "BHP", sector: mining)
arm = Company.create(name: "ARM", sector: mining)
barrick = Company.create(name: "Barrick", sector: mining)
coal_india = Company.create(name: "Coal India", sector: mining)
newmont = Company.create(name: "Newmont", sector: mining)
verifier = Company.create!(name: "PwC", sector: auditing)

dollars = Unit.create!(name: "m$")
tonnes = Unit.create!(name: "tonnes of CO2")
ratio = Unit.create!(name: "tonnes of CO2/m$")
number = Unit.create!(name: "number")

revenue = Question.create!(text: "What is your total revenue?", unit: dollars)
emissions = Question.create!(text: "What are your GHG emissions (scope 1 and 2)?", unit: tonnes)
incidents = Question.create!(text: "How many significant environmental incidents (spills)?", unit: number)
fatalities = Question.create!(text: "How many employee fatalities have there been?", unit: number)

# --------- 2018 --------
# Glencore
Answer.create!(question: revenue, company: glencore, year: 2018, value: 0, unit: dollars, verifier: verifier)
Answer.create!(question: emissions, company: glencore, year: 2018, value: 17, unit: tonnes, verifier: verifier)
Answer.create!(question: incidents, company: glencore, year: 2018, value: 0, unit: number, verifier: verifier)
Answer.create!(question: fatalities, company: glencore, year: 2018, value: 1, unit: number, verifier: verifier)

# BHP
Answer.create!(question: revenue, company: bhp, year: 2018, value: 850, unit: dollars, verifier: verifier)
Answer.create!(question: emissions, company: bhp, year: 2018, value: 16, unit: tonnes, verifier: verifier)
Answer.create!(question: incidents, company: bhp, year: 2018, value: 2, unit: number, verifier: verifier)
Answer.create!(question: fatalities, company: bhp, year: 2018, value: 2, unit: number, verifier: verifier)

# ARM
Answer.create!(question: revenue, company: arm, year: 2018, value: 600, unit: dollars, verifier: verifier)
Answer.create!(question: emissions, company: arm, year: 2018, value: 13, unit: tonnes, verifier: verifier)
Answer.create!(question: incidents, company: arm, year: 2018, value: 1, unit: number, verifier: verifier)
Answer.create!(question: fatalities, company: arm, year: 2018, value: 0, unit: number, verifier: verifier)

# Barrick
Answer.create!(question: revenue, company: barrick, year: 2018, value: 950, unit: dollars, verifier: verifier)
Answer.create!(question: emissions, company: barrick, year: 2018, value: 15, unit: tonnes, verifier: verifier)
Answer.create!(question: incidents, company: barrick, year: 2018, value: 5, unit: number, verifier: verifier)
Answer.create!(question: fatalities, company: barrick, year: 2018, value: 3, unit: number, verifier: verifier)

# Coal India
Answer.create!(question: revenue, company: coal_india, year: 2018, value: 300, unit: dollars, verifier: verifier)
Answer.create!(question: emissions, company: coal_india, year: 2018, value: 5, unit: tonnes, verifier: verifier)
Answer.create!(question: incidents, company: coal_india, year: 2018, value: 0, unit: number, verifier: verifier)
Answer.create!(question: fatalities, company: coal_india, year: 2018, value: 1, unit: number, verifier: verifier)

# Newmont
Answer.create!(question: revenue, company: newmont, year: 2018, value: 600, unit: dollars, verifier: verifier)
Answer.create!(question: emissions, company: newmont, year: 2018, value: 8, unit: tonnes, verifier: verifier)
Answer.create!(question: incidents, company: newmont, year: 2018, value: 0, unit: number, verifier: verifier)
Answer.create!(question: fatalities, company: newmont, year: 2018, value: 2, unit: number, verifier: verifier)

# --------- 2017 --------
# Glencore
Answer.create!(question: revenue, company: glencore, year: 2017, value: 111111, unit: dollars, verifier: verifier)
Answer.create!(question: emissions, company: glencore, year: 2017, value: 17, unit: tonnes, verifier: verifier)
Answer.create!(question: incidents, company: glencore, year: 2017, value: 0, unit: number, verifier: verifier)
Answer.create!(question: fatalities, company: glencore, year: 2017, value: 4, unit: number, verifier: verifier)

# BHP
Answer.create!(question: revenue, company: bhp, year: 2017, value: 850, unit: dollars, verifier: verifier)
Answer.create!(question: emissions, company: bhp, year: 2017, value: 16, unit: tonnes, verifier: verifier)
Answer.create!(question: incidents, company: bhp, year: 2017, value: 2, unit: number, verifier: verifier)
Answer.create!(question: fatalities, company: bhp, year: 2017, value: 1, unit: number, verifier: verifier)

# ARM
Answer.create!(question: revenue, company: arm, year: 2017, value: 600, unit: dollars, verifier: verifier)
Answer.create!(question: emissions, company: arm, year: 2017, value: 13, unit: tonnes, verifier: verifier)
Answer.create!(question: incidents, company: arm, year: 2017, value: 1, unit: number, verifier: verifier)
Answer.create!(question: fatalities, company: arm, year: 2017, value: 0, unit: number, verifier: verifier)

# Barrick
Answer.create!(question: revenue, company: barrick, year: 2017, value: 950, unit: dollars, verifier: verifier)
Answer.create!(question: emissions, company: barrick, year: 2017, value: 15, unit: tonnes, verifier: verifier)
Answer.create!(question: incidents, company: barrick, year: 2017, value: 5, unit: number, verifier: verifier)
Answer.create!(question: fatalities, company: barrick, year: 2017, value: 5, unit: number, verifier: verifier)

# Coal India
Answer.create!(question: revenue, company: coal_india, year: 2017, value: 300, unit: dollars, verifier: verifier)
Answer.create!(question: emissions, company: coal_india, year: 2017, value: 5, unit: tonnes, verifier: verifier)
Answer.create!(question: incidents, company: coal_india, year: 2017, value: 0, unit: number, verifier: verifier)
Answer.create!(question: fatalities, company: coal_india, year: 2017, value: 1, unit: number, verifier: verifier)

# Newmont
Answer.create!(question: revenue, company: newmont, year: 2017, value: 600, unit: dollars, verifier: verifier)
Answer.create!(question: emissions, company: newmont, year: 2017, value: 8, unit: tonnes, verifier: verifier)
Answer.create!(question: incidents, company: newmont, year: 2017, value: 0, unit: number, verifier: verifier)
Answer.create!(question: fatalities, company: newmont, year: 2017, value: 1, unit: number, verifier: verifier)

greenhouse_revenue = Outcome.create!(
  name: "Greenhouse gas emission per million dollar revenue",
  higher_is_better: false,
  unit: ratio,
)

environment_incidents = Outcome.create!(
  name: "Environment incidents",
  higher_is_better: false,
  unit: number,
)

workplace_fatalities = Outcome.create!(
  name: "Workplace fatalities",
  higher_is_better: false,
  unit: number,
)

Identifier.create!(target: incidents, name: :gri_code, value: "GRI 306-3")
Identifier.create!(target: environment_incidents, name: :gri_code, value: "GRI 306-3")

Mapping.create!(outcome: greenhouse_revenue, question: emissions, divisor: revenue)
Mapping.create!(outcome: environment_incidents, question: incidents)
Mapping.create!(outcome: workplace_fatalities, question: fatalities)

environmental = Group.create!(name: "Environmental")
GroupMember.create!(group: environmental, member: greenhouse_revenue)
GroupMember.create!(group: environmental, member: environment_incidents)

social = Group.create!(name: "Social")
GroupMember.create!(group: social, member: workplace_fatalities)

esg = Group.create!(name: "ESG")
GroupMember.create!(group: esg, member: environmental)
GroupMember.create!(group: esg, member: social)

OutcomeValue.refresh
CompanyRanking.refresh
