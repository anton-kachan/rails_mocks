# frozen_string_literal: true

module RailsMocks
  class Stub
    include RSpec::Mocks::ExampleMethods

    def initialize(stub)
      @stub = stub
    end

    def execute(scope)
      if stub[:allow]
        scope.allow(allow).to(receiver)
      elsif stub[:allow_any_instance_of]
        scope.allow_any_instance_of(allow_any_instance_of).to(receiver)
      end
    end

    private

    attr_reader :stub

    def allow
      stub[:allow].constantize
    end

    def allow_any_instance_of
      stub[:allow_any_instance_of].constantize
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