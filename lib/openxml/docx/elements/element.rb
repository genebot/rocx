module OpenXml
  module Docx
    module Elements
      class Element
        include AttributeBuilder

        class << self
          attr_reader :property_name
          attr_reader :namespace

          def tag(*args)
            @tag = args.first if args.any?
            @tag
          end

          def name(*args)
            @property_name = args.first if args.any?
            @property_name
          end

          def namespace(*args)
            @namespace = args.first if args.any?
            @namespace
          end

        end

        def initialize(options={})
          if options.fetch(:scaffold, false)
            @options = options # Make available for scaffolding if needed
            build_scaffold
          end

          options.each do |(attr_name, value)|
            self.public_send("#{attr_name}=", value) if self.respond_to? :"#{attr_name}="
          end

          if block_given?
            block = Proc.new
            if block.arity == 0
              instance_eval(&block)
            else
              yield self
            end
          end
        end

        def tag
          self.class.tag || default_tag
        end

        def name
          self.class.property_name || default_name
        end

        def namespace
          self.class.namespace || default_namespace
        end

        def to_xml(xml)
          xml[namespace].public_send(tag, xml_attributes)
        end

      private
        attr_reader :options

        # Override in subclasses to set up default attributes, properties, and children
        # when the `build` class method is used to construct the object
        def build_scaffold
        end

        def default_tag
          (class_name[0, 1].downcase + class_name[1..-1]).to_sym
        end

        def default_name
          class_name.gsub(/(.)([A-Z])/, '\1_\2').downcase
        end

        def default_namespace
          :w
        end

        def class_name
          self.class.to_s.split(/::/).last
        end

      end
    end
  end
end
