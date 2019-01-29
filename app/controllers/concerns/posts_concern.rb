module PostsConcern
  extend ActiveSupport::Concern

  def index
    @posts = Post.filter(params.permit(
      :filter => [
        :source_id,
        :source_type,
        :official,
        :author_name,
        :body
      ]
    )).paginate(
      :page => param_current_page,
      :per_page => param_per_page
    )
  end

  def show
    @post = Post.find params[:id]
  end
end
