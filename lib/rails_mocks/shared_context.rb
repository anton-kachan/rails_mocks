# frozen_string_literal: true

module RailsMocks
  class SharedContext

    def initialize(context_name)
      @context_name = context_name
    end

    def execute(scope)
      scope.instance_exec(&context_definition)
      scope.hooks.send(:run_owned_hooks_for, :before, :example, scope)
    end

    private

    attr_reader :context_name

    def context_definition
     RSpec.world.shared_example_group_registry
          .send(:shared_example_groups)[:main][context_name].definition
    end
  end
end