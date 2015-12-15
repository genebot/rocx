module OpenXml
  module DrawingML
    module Elements
      class NonVisualPictureDrawingProperties < OpenXml::Docx::Elements::Container
        namespace :pic
        tag :cNvPicPr

        attribute :preferRelativeResize, expects: :true_or_false
      end
    end
  end
end
