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

contents = CSV.open(
  'event_attendees_full.csv',
  headers: true,
  header_converters: :symbol
)

hour_count = Hash.new(0)

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  add_hour(row[:regdate], hour_count)

  # puts "#{name} #{phone}"
end

most_popular_hour, most_popular_hour_count = hour_count.max_by { |key, value| value }
puts "Most popular hour: #{most_popular_hour} with #{most_popular_hour_count} people registering."