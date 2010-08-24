require 'active_record'

module Newscloud
  module Acts
    module widgetable

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_widgetable

          include Newscloud::Acts::widgetable::InstanceMethods
          extend Newscloud::Acts::widgetable::RefineClassMethods
        end
      end

      module RefineClassMethods

        def widgetable?
          true
        end

        def widget_methods
          []
        end

        def valid_method? method_name
          self.widget_methods.include? method_name
        end

        def valid

        def refine(params)
          widgetable_params = ['sort_by', 'category', 'section']
          
          chains = []
          params.each do |key, value|
            value = self.filtered_value value
            next unless widgetable_params.index(key)
            if key == 'sort_by'
            	value = value.downcase
              chains << value if self.respond_to?(value) and self.valid_refine_type?(value)
            elsif key == 'category'
            elsif key == 'section'
            end
          end

          # TODO:: clean this up
          if chains.empty?
          	if self.respond_to? :active
              result = self.active.all(:limit => 10, :order => "created_at desc")
            else
              result = self.all(:limit => 10, :order => "created_at desc")
            end
          else
            chains.unshift 'active' if self.respond_to? :active
            result = chains.inject(self) { |chain, scope| chain.send(scope) }
          end
          result
        end

        def filtered_value value
          case value.downcase
            when 'top_rated'
              'top'
            else
            	value
          end
        end

        def valid_refine_type? value
          ['newest', 'top'].include? value.downcase
        end

        def self.widgetable_select_options
          ['Newest', 'Top'].collect { |k| [k, k] }
        end

      end

      module InstanceMethods

        def widgetable?
          true
        end

      end
    end
  end
end
