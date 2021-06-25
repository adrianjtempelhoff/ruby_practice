prime1 = 1013.to_f
prime2 = 1009.to_f
semi_prime = prime1  * prime2 
puts semi_prime
puts "------"
#puts semi_prime / 10

st = Time.now
a = []
[*1...semi_prime / 10].each do |i|
  a << i if (semi_prime.to_f % i.to_f).to_f == 0.0
  puts semi_prime / i if (semi_prime.to_f % i.to_f).to_f == 0.0
end
et = Time.now
puts "time: #{et - st}"

puts a.count == 3