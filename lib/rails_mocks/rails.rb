# frozen_string_literal: true

module RailsMocks
  class Railtie < Rails::Railtie
    initializer "rails_mocks.configure_rails_initialization" do
      insert_middleware
      load_shared_contexts
    end

    def insert_middleware
      app.middleware.use RailsMocks::Middleware
    end

    def load_shared_contexts
      Dir[Rails.root.join('spec/support/shared_contexts/**/*.rb')].each { |f| require f }
    end

    def app
      Rails.application
    end
  end
end
