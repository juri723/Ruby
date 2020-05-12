module RSpec
  module Rails
    # @api public
    # Container class for model spec functionality. Does not provide anything
    # special over the commons RailsExampleGroup currently.
    module ModelExampleGroup
      extend ActiveSupport::Concern
      include RSpec::Rails::RailsExampleGroup
    end
  end
end
