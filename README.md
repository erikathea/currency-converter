# exercise: currency-converter
===

WSDL Source: http://webservicex.net/currencyconvertor.asmx?wsdl


Running locally
---

Usage: `converter.rb [fromCurrency] [toCurrency] [option]`

    -v, --value=NUMBER               Add value to convert

    -p, --params                     Display list of accepted parameters

    -h, --help                       Display help


Running via Docker
---

1. Build `docker build -t currency-converter .`
2. Run `docker run -it currency-converter`

Note: You can change `CMD` of `Dockerfile`

`CMD ["./converter.rb", "param1", "param2", "option*", "option value*"]`

*optional

