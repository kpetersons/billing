module Prawn
  module Graphics
    # Use Prawn::Graphics::Transformation#translate and
    # Prawn::Graphics::Transformation#scale to adjust
    # the position and scale of these graphics within
    # your document
    def line
      fill do
        rectangle([0.346, 0.518], 544.305, 0.518)
      end
    end
  end
end
