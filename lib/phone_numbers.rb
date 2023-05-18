require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]
end

def clean_phone_number(phone_number)
  phone_number.gsub!(/\D/, '')
  if phone_number.nil? || phone_number.length < 10 || phone_number.length > 11 ||
  (phone_number.length == 11 && phone_number[0] != '1')
    phone_number = ''
    return
  end

  phone_number = phone_number[-10..-1]
  phone_number.to_s.insert(6, '-').insert(3, ')').insert(0, '(')
end

contents = CSV.open(
  'event_attendees_full.csv',
  headers: true,
  header_converters: :symbol
)

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  phone = clean_phone_number(row[:homephone])

  puts "#{name} #{phone}"
end