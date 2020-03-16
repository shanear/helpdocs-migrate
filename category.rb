require_relative './helpdocs'

class Category
  API_URL = "https://api.helpdocs.io/v1/category"

  attr_reader :id, :title

  def initialize(json:)
    @id = json["category_id"]
    @title = json["title"]
  end

  class << self
    def find_by_title(instance, title)
      find_all(instance).select do |category|
        category.title == title
      end.first
    end

    def find(instance, id)
      response = Helpdocs.http(instance).get("#{API_URL}/#{id}")
      Category.new(json: JSON.parse(response)["category"])
    end

    def find_all(instance)
      response = Helpdocs.http(instance).get(API_URL)

      @all ||= {}
      @all[instance] ||= JSON.parse(response)["categories"].map do |category_json|
        Category.new(json: category_json)
      end
    end
  end
end