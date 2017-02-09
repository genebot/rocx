require "openxml/docx/chainable_nested_context"

module OpenXml
  module Docx
    class Style
      include AttributeBuilder
      include PropertyBuilder

      attr_reader :type

      attribute :custom, expects: :boolean, displays_as: :customStyle, namespace: :w
      attribute :default, expects: :boolean, namespace: :w
      attribute :id, expects: :string, displays_as: :styleId, namespace: :w
      attribute :type, expects: :valid_style_type, namespace: :w

      value_property :auto_redefine, as: :style_auto_redefinition
      value_property :hidden_style
      value_property :linked_style
      value_property :locked, as: :style_lock
      value_property :next_style
      value_property :parent_style
      value_property :personal
      value_property :personal_compose
      value_property :personal_reply
      value_property :primary_style
      value_property :semi_hidden
      value_property :style_name
      value_property :ui_priority
      value_property :unhide_when_used

      def initialize(type)
        self.type = type
      end

      def type=(value)
        @type = value
        send "install_#{value}_properties"
      end

      def paragraph
        @paragraph.instance_variable_set "@self_was", self
        @paragraph
      end

      def character
        @character.instance_variable_set "@self_was", self
        @character
      end

      def table
        @table.instance_variable_set "@self_was", self
        @table
      end

      def tag
        :style
      end

      def name
        "style"
      end

      def to_xml(xml)
        xml["w"].public_send(tag, xml_attributes) {
          property_xml(xml)
        }
      end

      def paragraph_style?
        type == :paragraph
      end

      def character_style?
        type == :character
      end

      def table_style?
        type == :table
      end

      VALID_STYLE_TYPES = %i(character paragraph table)

    private

      def install_paragraph_properties
        @table = nil
        @character = OpenXml::Docx::Elements::Run.new
        @paragraph = OpenXml::Docx::Elements::Paragraph.new
        @character.extend OpenXml::Docx::ChainableNestedContext
        @paragraph.extend OpenXml::Docx::ChainableNestedContext
      end

      def install_character_properties
        @paragraph = nil
        @table = nil
        @character = OpenXml::Docx::Elements::Run.new
        @character.extend OpenXml::Docx::ChainableNestedContext
      end

      def install_table_properties
        @character = nil
        @paragraph = nil
        @table = OpenXml::Docx::Elements::Table.new
        @table.extend OpenXml::Docx::ChainableNestedContext
      end

      def property_xml(xml)
        style_property_xml(xml)

        return table.property_xml(xml) if table_style?
        character.property_xml(xml)
        paragraph.property_xml(xml) if paragraph_style?
      end

      def style_property_xml(xml)
        props = properties.keys.map(&method(:send)).compact
        return if props.none?(&:render?)
        props.each { |prop| prop.to_xml(xml) }
      end

      def valid_style_type(value)
        valid_in? value, VALID_STYLE_TYPES
      end

    end
  end
end
