class Importer
  API_CREDENTIALS = "api-credentials.json"
  SPREADSHEET = "mining"

  attr_accessor :rows, :cols

  def initialize
    self.rows = worksheet.rows
    self.cols = rows.transpose
  end

  def run
    mining = Sector.create!(name: sector_name)
    auditing = Sector.create(name: "Auditing")

    company_names.each do |name|
      Company.create!(name: name, sector: mining)
    end

    auditor_names.each do |name|
      Company.create!(name: name, sector: auditing)
    end

    esg = Group.create(name: "ESG")

    groups = esg_names.uniq.map do |name|
      next if name == "-"

      group = Group.create!(name: name)
      GroupMember.create(group: esg, member: group)
    end

    question_texts.zip(esg_names, gri_codes, unit_names, higher_is_better).each do |text, esg_name, code, name, higher|
      unit = Unit.find_or_create_by!(name: name)
      group = Group.find_by!(name: esg_name) unless esg_name == "-"

      question = Question.create!(text: text, unit: unit)
      outcome = Outcome.create!(name: text, unit: unit, higher_is_better: higher)

      Mapping.create!(question: question, outcome: outcome)
      GroupMember.create!(group: group, member: outcome) if group

      if code.present?
        code = code.split(",").first

        Identifier.create(name: "gri_code", value: code, target: question)
        Identifier.create(name: "gri_code", value: code, target: outcome)
      end

      mining.companies.each do |company|
        answer = answer_for(company.name, question.text)
        next if answer.blank?

        answer.split(",").each_slice(2).zip(years) do |(value, auditor_key), year|
          next if value == "-"

          auditor_name = auditor_name_for(auditor_key, answer)
          auditor = Company.find_by!(name: auditor_name) if auditor_name

          Answer.create!(
            value: value,
            question: question,
            company: company,
            unit: unit,
            year: year,
            verifier: auditor,
          )
        end
      end
    end

    OutcomeValue.refresh
    CompanyRanking.refresh
  end

  private

  def auditor_name_for(auditor_key, answer)
    auditor_key&.strip!

    return if auditor_key.blank? || auditor_key == "-"
    index = auditor_keys.index(auditor_key)

    auditor_names[index]
  end

  def answer_for(company_name, question_text)
    company_index = company_names.index(company_name)
    question_index = question_texts.index(question_text)

    cols[7 + company_index][4 + question_index]
  end

  def company_names
    rows.first[7..]
  end

  def auditor_keys
    cols[1][70..].take_while(&:present?)
  end

  def auditor_names
    cols[2][70..].take_while(&:present?)
  end

  def esg_names
    cols[2][4..].take_while(&:present?)
  end

  def gri_codes
    cols[3][4..]
  end

  def question_texts
    cols[4][4..].take_while(&:present?)
  end

  def unit_names
    cols[5][4..].take_while(&:present?)
  end

  def higher_is_better
    cols[6][4..].take_while(&:present?).map { |v| v == "y" }
  end

  def sector_name
    SPREADSHEET.capitalize
  end

  def years
    (2000..2018).reverse_each
  end

  def worksheet
    session.spreadsheet_by_title(SPREADSHEET).worksheets.first
  end

  def session
    GoogleDrive::Session.from_service_account_key(API_CREDENTIALS)
  end
end
