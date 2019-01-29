module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(filtering_params)
      filtering_params = filtering_params[:filter] if filtering_params.key? :filter

      results = self.where nil

      filtering_params.each do |key, value|
        value = nil if value == 'null'
        key   = "filter_#{key}"

        if self.respond_to?(key) && value.to_s != '0'
          results = results.public_send key, value
        end
      end

      results
    end
  end
end
