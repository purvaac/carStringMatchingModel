class CarModelsController < ApplicationController
  require 'fuzzy_match'

  def index
  end
  

  #match function to extract model name
  def match
    user_input = params[:model_name].downcase
    normalized_input = normalize(user_input)
    model = extract_model(normalized_input)
    
    car_models = CarModel.all.pluck(:database_name)
    normalized_db = car_models.map { |name| [name, normalize(name)] }.to_h

    #debugging stmt
    puts "Model: #{model}" 
    puts "Normalized DB: #{normalized_db}" 

    fuzzy_match = FuzzyMatch.new(normalized_db.keys)
    best_match, percentage = fuzzy_match.find_with_score(model)

    #debugging stmt
    puts "Best Match: #{best_match}" # print best_match to console
    puts "Percentage: #{percentage}"
    if best_match
      @result = { best_match: best_match, similarity: (percentage * 100).round(2) }
    else
      @result = { best_match: "No match found", similarity: 0 }
    end

    #debugging stmt
    puts "@result: #{@result.inspect}"

    render :match
  end

  private


  #to normalize the user input
  def normalize(input)
    input.downcase.gsub(/[^a-z0-9\s]/, '')
  end

  #function to extract model name from given input string
  def extract_model(input_string)

    #get models from database
    car_models = CarModel.all.pluck(:database_name)
    car_models.each do |company|

      #see if input contains company name
      if input_string.include?(company)
        model_start_index = input_string.index(company) + company.length
        model_end_index = input_string.index(' ', model_start_index) || input_string.length

        #get the model name from input
        model_name = input_string[model_start_index...model_end_index].strip

        other_models = car_models.reject { |m| m == company }
        other_models.each do |other_model|
          return other_model if other_model.include?(model_name)
        end

        return model_name
      end
    end

    input_string
  end
end
