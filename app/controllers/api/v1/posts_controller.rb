class Api::V1::PostsController < Api::V1::ApplicationController
  include PostsConcern

  def index
    super

    render :json => @posts,
      :meta => {
        :current_page => @posts.current_page,
        :total_pages => @posts.total_pages,
        :total_entries => @posts.total_entries
      },
      :include => %w(source)
  end

  def show
    super

    render :json => @post,
      :include => %w(source)
  end
end
