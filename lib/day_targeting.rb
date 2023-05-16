require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'date'
require 'time'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]
end

def clean_phone_number(phone_number)
  phone_number.gsub!(/\D/, '')
  if phone_number.nil? || phone_number.length < 10 || phone_number.length > 11 ||
  (phone_number.length == 11 && phone_number[0] != '1')
    phone_number = ''
  end

  phone_number[-10..-1]
end

def add_hour(registered_time, hour_hash)
  hour = DateTime.strptime(registered_time, "%m/%d/%y %H:%M").hour
  hour_hash[hour] += 1
  hour_hash
end

def add_day(registered_day, day_hash)
    day = DateTime.strptime(registered_day, "%m/%d/%y %H:%M").wday
    day_hash[day] += 1
    day_hash
end

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

day_count = Hash.new(0)

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  add_day(row[:regdate], day_count)
end

most_popular_day, most_popular_day_count = day_count.max_by { |key, value| value }
puts "Most popular day: #{Date::DAYNAMES[most_popular_day]} with #{most_popular_day_count} people registering."