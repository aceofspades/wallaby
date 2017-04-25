module Wallaby
  # Resources helper
  module ResourcesHelper
    include Wallaby::FormHelper
    include Wallaby::SortingHelper
    include Wallaby::PaginatableHelper

    def decorate(resource)
      if resource.respond_to? :map # collection
        decorator = Wallaby::DecoratorFinder.find_resource resource.first.class
        resource.map do |item|
          decorator.decorate item
        end
      else
        decorator = Wallaby::DecoratorFinder.find_resource resource.class
        decorator.decorate resource
      end
    end

    def extract(resource)
      if resource.is_a? Wallaby::ResourceDecorator
        resource.resource
      else
        resource
      end
    end

    def model_decorator(model_class)
      Wallaby::DecoratorFinder.find_model model_class
    end

    def model_servicer(model_decorator)
      model_class = model_decorator.model_class
      Wallaby::ServicerFinder.find(model_class).new model_class, model_decorator
    end

    def type_partial_render(options = {},
                            locals = {},
                            metadata_method = :show_metadata_of, &block)
      decorated   = locals[:object]
      field_name  = locals[:field_name].to_s

      unless field_name.present? && decorated.is_a?(Wallaby::ResourceDecorator)
        raise ArgumentError
      end

      locals[:metadata] = decorated.send metadata_method, field_name
      locals[:value]    = decorated.public_send field_name

      render(options, locals, &block) || render('string', locals, &block)
    end

    def index_type_partial_render(options = {}, locals = {}, &block)
      type_partial_render options, locals, :index_metadata_of, &block
    end

    def show_title(decorated)
      raise ArgumentError unless decorated.is_a? Wallaby::ResourceDecorator
      [to_model_label(decorated.model_class), decorated.to_label] \
        .compact.join ': '
    end
  end
end