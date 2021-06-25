
# prime number(s)
# if a number is only divisible by itself and by one

# number = 40
# a = []
# [*1..number].each do |i|
  # a << i if (number.to_f % i.to_f).to_f == 0.0
  # puts i if (number.to_f % i.to_f).to_f  == 0.0
# end

# puts a.count < 3


def test number
#number = 40
a = []
[*1..number].each do |i|
  a << i if (number.to_f % i.to_f).to_f == 0.0
  #puts i if (number.to_f % i.to_f).to_f  == 0.0
end

return a.count < 3
end

primes = []
[*100..1000].each do |i|
primes << i if test i
end

puts primes
