# frozen_string_literal: true

module RailsMocks
  class Stub
    include RSpec::Mocks::ExampleMethods

    def initialize(stub)
      @stub = stub
    end

    def execute(scope)
      scope.allow(allow).to(receiver)
    end

    private

    attr_reader :stub

    def allow
      stub[:allow].constantize
    end

    def receiver
      receiver = receive(_receive)
      receiver.with(_with) if _with
      receiver.and_return(_and_return) if _and_return
      receiver
    end

    def _receive
      stub[:receive]
    end

    def _with
      fetch_data(:with)
    end

    def _and_return
      fetch_data(:and_return)
    end

    def fetch_data(key)
      data = stub.fetch(key, {})
      body = data[:body]
      return double(body) if wrap_double?(data)
      body
    end

    def wrap_double?(data)
      data[:double]
    end
  end
end