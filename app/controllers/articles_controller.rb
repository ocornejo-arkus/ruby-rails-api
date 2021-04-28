class ArticlesController < ApplicationController
    skip_before_action :authorize!, only: [:index, :show]

    include Paginable

    def index
        paginated = paginate(Article.recent)
        render_collection(paginated)
    end

    def show
        article = Article.find(params[:id])
        render json: serializer.new(article)

    # Captura los errores para mostrar en api.
    # rescue ActiveRecord::RecordNotFound => e
    #     render json: { message: e.message, detail: "Here will be nicely formatted response" }
    end

    private
        def serializer
            ArticleSerializer
        end
end