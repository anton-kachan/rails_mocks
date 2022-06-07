# frozen_string_literal: true

module RailsMocks
  class Middleware
    include RSpec::Core::Hooks
    include ProtoPharm::RSpec::DSL
    include RSpec::Mocks::ExampleMethods

    alias :let :define_singleton_method
    def metadata; end

    def initialize(app)
      @app = app
    end

    def call(req)
      header_data = RailsMocks::HeaderData.new(req)
      return @app.call(req) if header_data.empty?

      status, headers, response = nil

      RSpec::Mocks.with_temporary_scope do
        RSpec::Mocks::Syntax.enable_expect(self.class)
        self.instance_variable_set(:@hooks, nil)

        header_data.run_shared_contexts(self)
        header_data.run_stubs(self)

        status, headers, response = @app.call(req)
      end
      [status, headers, response]
    end
  end
end