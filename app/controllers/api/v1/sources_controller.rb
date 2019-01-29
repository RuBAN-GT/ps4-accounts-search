class Api::V1::SourcesController < Api::V1::ApplicationController
  def index
    @sources = Source.all

    render :json => @sources
  end

  def show
    @source = Source.find params[:id]

    render :json => @source
  end
end
