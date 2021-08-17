# frozen_string_literal: true

module RailsMocks
  class HeaderData
    MOCKS_HEADER = "HTTP_RAILS_MOCKS"
    CONTEXTS_HEADER = "HTTP_RAILS_CONTEXTS"

    def initialize(req)
      @mocks_data = req[MOCKS_HEADER]
      @shared_contexts_data = req[CONTEXTS_HEADER]
    end

    def run_shared_contexts(scope)
      parsed_shared_contexts.each do |shared_context|
        shared_context.execute(scope)
      end
    end

    def run_stubs(scope)
      parsed_stubs.each do |stub|
        stub.execute(scope)
      end
    end

    def empty?
      mocks_data.blank? && shared_contexts_data.blank?
    end

    private

    attr_reader :mocks_data, :shared_contexts_data

    def parsed_stubs
      return [] if mocks_data.blank?
      JSON.parse(mocks_data, symbolize_names: true).map do |stub|
        RailsMocks::Stub.new(stub)
      end
    end

    def parsed_shared_contexts
      return [] if shared_contexts_data.blank?
      JSON.parse(shared_contexts_data).map do |shared_context_name|
        RailsMocks::SharedContext.new(shared_context_name)
      end
    end
  end
end