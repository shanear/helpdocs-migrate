require 'json'
require 'pp'

require_relative './helpdocs'
require_relative './category'

class Article
  API_URL = "https://api.helpdocs.io/v1/article"

  attr_reader :id, :title, :body, :description, :short_version

  def initialize(json:, instance:)
    @id = json["article_id"]
    @title = json["title"]
    @body = json["body"]
    @category_id = json["category_id"]
    @slug = json["slug"]
    @tags = json["tags"]
    @description = json["description"]
    @short_version = json["short_version"]
    @instance = instance
  end

  def update_from!(article)
    Helpdocs.http(@instance).patch(
      "#{API_URL}/#{id}",
      json: {
        title: article.title,
        body: article.body,
        description: article.description,
        short_version: article.short_version,
        user_id: migration_user_id
      }
    )
  end

  def create_in!(instance)
    Helpdocs.http(instance).post(
      API_URL,
      json: {
        title: title,
        body: body,
        category_id: category_in_destination.id,
        description: description,
        short_version: short_version,
        slug: @slug,
        tags: @tags,
        is_private: false,
        is_published: true,
        user_id: migration_user_id
      }
    )
  end

  def to_s
    "#{title}\n\n#{body}"
  end

  # Maps to Shane, used to tell which questions were auto created/updated
  def migration_user_id
    "t7y3x2xpau" 
  end

  def category_in_destination
    @category_in_destination ||= Category.find_by_title(:destination, category.title)
  end

  def category
    @category ||= Category.find(@instance, @category_id)
  end

  def self.find_all(instance)
    response = Helpdocs.http(instance).get("#{API_URL}?include_body=true")

    JSON.parse(response)["articles"].map do |article_json|
      Article.new(json: article_json, instance: instance)
    end
  end
end