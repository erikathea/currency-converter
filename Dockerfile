FROM ruby:2.2-onbuild
CMD ["./converter.rb", "USD", "PHP", "-v", "2"]
