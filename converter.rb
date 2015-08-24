require 'savon'

client = Savon::Client.new(wsdl: "http://webservicex.net/currencyconvertor.asmx?wsdl")

#TODO: set values of fromCurrency & toCurrency

response = client.call(:conversion_rate, :message => {"FromCurrency" => fromCurrency, "ToCurrency" => toCurrency})
response.body

