require_relative './article'

class ArticleMigration
  def execute!
    source_articles.each do |article|
      destination_article = matching_destination_article(article)

      if destination_article
        puts "[UPDATE] #{article.title}"
        destination_article.update_from!(article)
      else
        puts "[CREATE] #{article.title}"
        article.create_in!(:destination)
      end
    end
  end

  def matching_destination_article(article_to_match)
    destination_articles.select do |article|
      article.title == article_to_match.title
    end.first
  end

  def source_articles
    @source_articles = Article.find_all(:source)
  end

  def destination_articles
    @destination_articles = Article.find_all(:destination)
  end
end

ArticleMigration.new.execute!
