#!/usr/bin/env ruby

require 'rubygems'
require 'optparse'
require 'savon'
require 'curl'
require 'nokogiri'
require 'bigdecimal'

options = {}
params = ['AFA', 'ALL', 'DZD', 'ARS', 'AWG',
    'AUD', 'BSD', 'BHD', 'BDT', 'BBD', 'BZD', 'BMD',
    'BTN', 'BOB', 'BWP', 'BRL', 'GBP', 'BND', 'BIF',
    'XOF', 'XAF', 'KHR', 'CAD', 'CVE', 'KYD', 'CLP',
    'CNY', 'COP', 'KMF', 'CRC', 'HRK', 'CUP', 'CYP',
    'CZK', 'DKK', 'DJF', 'DOP', 'XCD', 'EGP', 'SVC',
    'EEK', 'ETB', 'EUR', 'FKP', 'GMD', 'GHC', 'GIP',
    'XAU', 'GTQ', 'GNF', 'GYD', 'HTG', 'HNL', 'HKD',
    'HUF', 'ISK', 'INR', 'IDR', 'IQD', 'ILS', 'JMD',
    'JPY', 'JOD', 'KZT', 'KES', 'KRW', 'KWD', 'LAK',
    'LVL', 'LBP', 'LSL', 'LRD', 'LYD', 'LTL', 'MOP',
    'MKD', 'MGF', 'MWK', 'MYR', 'MVR', 'MTL', 'MRO',
    'MUR', 'MXN', 'MDL', 'MNT', 'MAD', 'MZM', 'MMK',
    'NAD', 'NPR', 'ANG', 'NZD', 'NIO', 'NGN', 'KPW',
    'NOK', 'OMR', 'XPF', 'PKR', 'XPD', 'PAB', 'PGK',
    'PYG', 'PEN', 'PHP', 'XPT', 'PLN', 'QAR', 'ROL',
    'RUB', 'WST', 'STD', 'SAR', 'SCR', 'SLL', 'XAG',
    'SGD', 'SKK', 'SIT', 'SBD', 'SOS', 'ZAR', 'LKR',
    'SHP', 'SDD', 'SRG', 'SZL', 'SEK', 'CHF', 'SYP',
    'TWD', 'TZS', 'THB', 'TOP', 'TTD', 'TND', 'TRL',
    'USD', 'AED', 'UGX', 'UAH', 'UYU', 'VUV', 'VEB',
    'VND', 'YER', 'YUM', 'ZMK', 'ZWD', 'TRY'
    ]
OptionParser.new do |opts|
  opts.banner = "Usage: converter.rb [fromCurrency] [toCurrency] [option]"

  opts.on("-v", "--value=NUMBER", "Add value to convert") do |v|
    options[:value] = v
  end
  opts.on("-p", "--params", "Display list of accepted parameters") do
    puts params
    exit
  end
  opts.on("-h", "--help", "Display help") do
    puts opts
    exit
  end
end.parse!

if ARGV.length < 2
  puts "Try running with help option -h, --help ..."
  exit
end

fromCurrency = ARGV[0]
toCurrency = ARGV[1]
unless (params.include?(fromCurrency) && params.include?(toCurrency))
  puts "Invalid parameters. Please refer to the list of params. Run -p"
  exit
end

params = {"FromCurrency" => fromCurrency, "ToCurrency" => toCurrency}
puts "Converting #{fromCurrency} to #{toCurrency}"

wsdl = 0.0
begin
  client = Savon::Client.new(wsdl: "http://webservicex.net/currencyconvertor.asmx?wsdl")
  response = client.call(:conversion_rate, :message => params)
  wsdl = response.body[:conversion_rate_response][:conversion_rate_result]
rescue Savon::SOAPFault => error
  # puts error
  puts "Error occured. Please check your parameters."
end
puts "Result using Savon #{wsdl}"

rest = 0.0
begin
  http = Curl.get('http://www.webservicex.net/CurrencyConvertor.asmx/ConversionRate', params)
  xml = Nokogiri::XML(http.body_str)
  result = xml.at_xpath("//xmlns:double")
  rest = result.inner_html
rescue
  # puts http.body_str
  puts "Error occured. Please check your parameters."
end
puts "Result using Curl #{rest}"

unless options[:value].empty?
  converted_value = BigDecimal.new(wsdl) * BigDecimal.new(options[:value])
  puts "#{options[:value]} #{fromCurrency} to #{converted_value.to_f} #{toCurrency}"
end
