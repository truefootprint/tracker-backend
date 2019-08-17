class Importer
  API_CREDENTIALS = "config/google-sheets.json"
  SPREADSHEET = "mining"

  attr_accessor :rows, :cols

  def initialize
    self.rows = worksheet.rows
    self.cols = rows.transpose
  end

  def run
    mining = Sector.create!(name: sector_name)
    auditing = Sector.create(name: "Auditing")

    company_names.zip(company_logos).each do |name, logo|
      Company.create!(name: name, sector: mining, logo: logo)
    end

    auditor_names.zip(auditor_logos).each do |name, logo|
      Company.create!(name: name, logo: logo, sector: auditing)
    end

    esg = Group.create(name: "ESG")

    esg_names.uniq.map do |name|
      next if name == "-"

      group = Group.create!(name: name)
      GroupMember.create(group: esg, member: group)
    end

    question_texts.zip(ratio_mappings, esg_names, gri_codes, unit_names, higher_is_better)
      .each do |text, ratio, esg_name, code, name, higher|

      unit = Unit.find_or_create_by!(name: name) if name.present?
      group = Group.find_by!(name: esg_name) unless esg_name == "-"

      if ratio
        question_text, divisor_text = ratio

        question = Question.find_by!(text: question_text)
        divisor = Question.find_by!(text: divisor_text)
      else
        question = Question.create!(text: text, unit: unit)
        divisor = nil
      end

      outcome = Outcome.create!(name: text, unit: unit, higher_is_better: higher)

      Mapping.create!(question: question, divisor: divisor, outcome: outcome)
      GroupMember.create!(group: group, member: outcome) if group

      if code.present?
        code = code.split(",").first

        #Identifier.create(name: "gri_code", value: code, target: question)
        #Identifier.create(name: "gri_code", value: code, target: outcome)
      end

      mining.companies.each do |company|
        next if ratio

        answer = answer_for(company.name, question.text)
        next if answer.blank?

        answer.split(",").each_slice(2).zip(years) do |(value, auditor_key), year|
          next if value == "-"
          raise "#{answer.inspect} looks invalid" if value.to_f < 0

          auditor_name = auditor_name_for(auditor_key, answer)
          auditor = Company.find_by!(name: auditor_name) if auditor_name

          Answer.create!(
            value: value,
            question: question,
            company: company,
            unit: unit,
            year: year,
            auditor: auditor,
          )
        end
      end
    end

    GroupWeight.create!(name: "25-25-50", group: Group.find_by!(name: "Environmental"), weight: 0.25)
    GroupWeight.create!(name: "25-25-50", group: Group.find_by!(name: "Social"), weight: 0.25)
    GroupWeight.create!(name: "25-25-50", group: Group.find_by!(name: "Governance"), weight: 0.5)

    GroupWeight.create!(name: "33-33-33", group: Group.find_by!(name: "Environmental"), weight: 0.33333333333)
    GroupWeight.create!(name: "33-33-33", group: Group.find_by!(name: "Social"), weight: 0.33333333333)
    GroupWeight.create!(name: "33-33-33", group: Group.find_by!(name: "Governance"), weight: 0.33333333333)

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

  def company_logos
    rows[69][7..].map(&:presence)
  end

  def auditor_keys
    cols[1][70..].take_while(&:present?)
  end

  def auditor_names
    cols[2][70..].take_while(&:present?)
  end

  def auditor_logos
    cols[4][70..].take_while(&:present?)
  end

  def ratio_mappings
    cols[0][4..].map do |ratio|
      ratio.split("/").map { |row| question_texts[row.to_i - 5] } unless ratio.blank?
    end
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
    cols[5][4..65]
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
