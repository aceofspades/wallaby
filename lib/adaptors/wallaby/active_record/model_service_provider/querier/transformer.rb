module Wallaby
  class ActiveRecord
    class ModelServiceProvider
      class Querier
        # Build up query using the results
        class Transformer < Parslet::Transform
          SIMPLE_OPERATORS = {
            ':' => :eq,
            ':=' => :eq,
            ':!' => :not_eq,
            ':!=' => :not_eq,
            ':<>' => :not_eq,
            ':~' => :matches,
            ':^' => :matches,
            ':$' => :matches,
            ':!~' => :does_not_match,
            ':!^' => :does_not_match,
            ':!$' => :does_not_match,
            ':>' => :gt,
            ':>=' => :gteq,
            ':<' => :lt,
            ':<=' => :lteq
          }.freeze

          SEQUENCE_OPERATORS = {
            ':' => :in,
            ':=' => :in,
            ':!' => :not_in,
            ':!=' => :not_in,
            ':<>' => :not_in,
            ':()' => :between,
            ':!()' => :not_between
          }.freeze

          rule keyword: simple(:value) do
            value.try :to_str
          end

          rule keyword: sequence(:value) do
            value.presence.try :map, :to_str
          end

          rule left: simple(:left), op: simple(:op), right: simple(:right) do
            oped = op.try :to_str
            operator = SIMPLE_OPERATORS[oped]
            next unless operator
            lefted = left.try :to_str
            convert = case oped
                      when ':~', ':!~' then "%#{right}%"
                      when ':^', ':!^' then "#{right}%"
                      when ':$', ':!$' then "%#{right}"
                      end
            { left: lefted, op: operator, right: convert || right }
          end

          rule left: simple(:left), op: simple(:op), right: sequence(:right) do
            oped = op.try :to_str
            operator = SEQUENCE_OPERATORS[oped]
            next unless operator
            lefted = left.try :to_str
            convert = if %w(:() :!()).include?(oped)
                        Range.new right.try(:first), right.try(:last)
                      end
            { left: lefted, op: operator, right: convert || right }
          end
        end
      end
    end
  end
end
