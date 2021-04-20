class ArticlesController < ApplicationController
    def index
        articles = Article.all
        render json: serializer.new(articles), status: :ok
    end

    def show
        render json: {}
    end

    private
        def serializer
            ArticleSerializer
        end
end