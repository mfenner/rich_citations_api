ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/test_unit'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  self.use_transactional_fixtures = true

  # Add more helper methods to be used by all tests here...

  # Infer as many values as we can based on the index
  def new_reference(options={}, &block)
    save = options.delete(:save)

    if options[:number]
      options[:ref_id] = "ref.#{options[:number]}"                unless options.has_key?(:ref_id)
    end

    if !options.has_key?(:cited_paper)
      uri = options.delete(:uri) || mk_random_uri
      bib = options.delete(:bibliographic)
      options[:cited_paper] = Paper.new(uri:uri, bibliographic:bib)
    end

    result = Reference.new(options)

    if block_given?
      if block.arity==0
        result.instance_eval &block
      else
        yield self
      end
    end

    result.save! if save
    result
  end

  def mk_random_uri
    "cited:#{SecureRandom.uuid}"
  end
end

class ActionController::TestResponse

  def json
    MultiJson.load(body)
  end

end
