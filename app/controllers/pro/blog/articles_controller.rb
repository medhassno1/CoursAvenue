# encoding: utf-8
class Pro::Blog::ArticlesController < Pro::ProController

  before_action :load_categories

  layout 'pro_blog'

  def index
    @articles   = ::Blog::Article::ProArticle.published.page(params[:page] || 1).per(5)
  end

  def show
    @article = ::Blog::Article::ProArticle.find params[:id]
  end

  def category_index
    @category = ::Blog::Category::ProCategory.find params[:category_id]
    @articles = @category.articles.published.page(params[:page] || 1).per(5)
  end

  private

  def load_categories
    @categories = ::Blog::Category::ProCategory.at_depth(0).order('position ASC NULLS LAST').all
  end
end
