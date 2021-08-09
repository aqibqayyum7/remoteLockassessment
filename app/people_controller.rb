class PeopleController
  require 'date'

  def initialize(params)
    @params = params
  end

  def normalize
    people_data = []

    people_data << percent_data_objects
    people_data << dollar_data_objects

    sorted_data_objects = people_data.flatten.sort_by! { |hsh| hsh[@params[:order].to_s] }
    sorted_data_arr = convert_hash_to_values(sorted_data_objects)

    sorted_data_arr.flatten
  end

  private

  def percent_data_objects
    splitted_data = @params[:percent_format].split("\n")

    data = []
    keys = splitted_data.first.split(" % ")
    splitted_data.each_with_index do |element, parent_index|
      obj = {}
      values = element.split(" % ") if parent_index > 0 #["usman", "sahiwal", "1947-05-04"]
      if parent_index > 0
        keys.each_with_index do |key, child_index|
          obj[key] = values[child_index]
          obj[key] = date_format(values[child_index]) if (key == "birthdate")
        end
        data << obj
      end
    end
    return data
  end

  def dollar_data_objects
    splitted_data = @params[:dollar_format].split("\n")

    data = []
    keys = splitted_data.first.split(" $ ")
    splitted_data.each_with_index do |element, parent_index|
      obj = {}
      values = element.split(" $ ") if parent_index > 0
      if parent_index > 0
        keys.each_with_index do |key, child_index|
          obj[key] = values[child_index] if key != "last_name"
          obj[key] = date_format(values[child_index]) if (key == "birthdate")
        end
        data << obj.to_a.reverse.to_h
      end
    end
    return data
  end

  def split_data(string_val, bases_on)
    string_val.split(bases_on)
  end

  def date_format(date)
    DateTime.parse(date).strftime("%m/%d/%Y")
  end

  def convert_hash_to_values(sorted_data_objects)
    sorted_data_arr = []
    sorted_data_objects.each do |data_obj|
      sorted_data_arr << data_obj.values.join(", ")
    end
    return sorted_data_arr
  end

  attr_reader :params
end
