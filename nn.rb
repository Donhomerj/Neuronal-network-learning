require 'csv'
require 'ruby-fann'
require 'byebug'

def run_ai neurons
  source_data = []
  result_data = []
  CSV.foreach("./data/schueler.csv", :headers => true) do |row|
    source_data.push( [row[0].to_f, row[1].to_f, row[2].to_f, row[3].to_f] )
    result_data.push( [row[4].to_f.round(2), row[5].to_f.round(2), row[6].to_f.round(2), row[7].to_f.round(2), row[8].to_f.round(2), row[9].to_f.round(2)])
  end

  test_size_percentage = 20.0
  test_set_size = source_data.size *  (test_size_percentage / 100.0)

  test_source_data = source_data[0...test_set_size ]
  test_result_data = result_data[0...test_set_size ]

  training_source_data = source_data[test_set_size..source_data.size]
  training_result_data = result_data[test_set_size..result_data.size]

  train_data = RubyFann::TrainData.new( :inputs =>
    training_source_data, :desired_outputs => training_result_data)

  model = RubyFann::Standard.new(
    num_inputs: 4,
    hidden_neurons: [neurons],
    num_outputs: 6 );

    puts "starting training with #{neurons}"
  model.train_on_data(train_data, 2000, 50, 0.005)

    puts "starts testing"
  prediction = []

  test_result_index = 0

  test_source_data.each do |params|
    result = model.run(params)
    real_number = result.map{|e| e}
    rounded = result.map{|e| e.round}
    correct = test_result_data[test_result_index] == rounded ? 1 : 0
    prediction.push( {:result => result, :real_number => real_number, :rounded => rounded, :correct => correct}  )
    test_result_index = test_result_index + 1
  end

  correct = prediction.collect.with_index {|e,i| e[:correct]}.inject {|sum,e| sum+e}
  puts "Count of correct: #{correct}"
  puts "Accuracy: #{((correct.to_f / test_set_size) * 100).round(2)}% - test set of size #{test_size_percentage}"
  ((correct.to_f / test_set_size)).round(4)
end

