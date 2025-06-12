# frozen_string_literal: true

module RuboCop
  module Cop
    module Custom
      # This cop warns when Active Record queries use `all` or `where`
      # without an explicit `.select(...)` clause.
      # Autocorrects to `.select(:id)` which needs to be expanded to all fields needed
      # by the developer.
      class ExplicitSelect < Base
        extend AutoCorrector

        MSG = 'Avoid using `%<method>s` without an explicit `.select(...)`. Autocorrecting to `.select(:id)`.'

        RESTRICT_ON_SEND = %i[all where].freeze

        def on_send(node)
          return unless inside_active_record_chain?(node)

          if node.method?(:all) || node.method?(:select) || node.method?(:where)
            unless select_present_in_chain?(node)
              add_offense(node, message: format(MSG, method: node.method_name)) do |corrector|
                append_select_id(corrector, node)
              end
            end
          end
        end

        private

        def inside_active_record_chain?(node)
          # Only apply if the receiver is a constant (e.g., `User.all`)
          node.receiver&.const_type?
        end

        def select_present_in_chain?(node)
          visited = Set.new

          while node
            return true if node.method?(:select) && node.arguments.any?

            # Avoid re-visiting the same node (paranoia guard)
            break if visited.include?(node)
            visited << node

            # Walk up the chain safely
            node = node.parent if node.parent&.send_type?
            break unless node&.send_type?
          end

          false
        end

        def append_select_id(corrector, node)
          insertion_point = node.source_range.end
          corrector.insert_after(insertion_point, '.select(:id)') # Developer must add additional fields beyond :id
        end
      end
    end
  end
end
