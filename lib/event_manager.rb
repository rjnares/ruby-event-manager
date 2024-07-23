require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def to_hour(date_and_time)
  Time.strptime(date_and_time, '%m/%d/%y %k:%M').hour
end

def sort_decreasing_by_count(counts)
  counts.sort_by { |key, count| count }.map(&:first).reverse
end

def clean_phone_number(phone_number)
  phone_number_digits = phone_number.gsub(/\D/, '')
  bad_phone_number = '0000000000'

  if phone_number_digits.length == 10
    phone_number_digits
  elsif phone_number_digits.length == 11 && phone_number_digits[0] == '1'
    phone_number_digits[1..-1]
  else
    bad_phone_number
  end
end

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id,form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter
registration_hour_counts = Hash.new(0)

contents.each do |row|
  id = row[0]
  registration_hour = to_hour(row[:regdate])
  registration_hour_counts[registration_hour] += 1
  name = row[:first_name]
  phone_number = clean_phone_number(row[:homephone])
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letter(id,form_letter)
end

peak_registration_hours = sort_decreasing_by_count(registration_hour_counts)
