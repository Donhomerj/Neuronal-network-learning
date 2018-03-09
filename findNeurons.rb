require './nn.rb'
require 'byebug'

def learn_next neurons
  run_ai neurons
end

result_table = Array.new 1000
for i in 0..result_table.length
  result_table[i] = 1
end

start_neurons = 10
next_step = Random.new.rand.round
next_step = next_step == 1 ? 1 : (-1)

neurons = start_neurons + next_step
value_before = 0
value_after = 0
100.times do |times|
  puts "run: #{times}"
  value_after = learn_next neurons
  if value_after > value_before
    next_step = next_step
  else
    next_step = next_step * (-1)
  end
  value_before = value_after
  puts "#{neurons} with success of #{value_after}"
  result_table[neurons] = result_table[neurons] * value_after
  neurons = neurons + next_step * (1 + Random.rand(4)).round

  if neurons < 0
    neurons = 1
  end

  if neurons > 999
    neurons = 999
  end
end
byebug
puts result_table.each_with_index.max[3]
