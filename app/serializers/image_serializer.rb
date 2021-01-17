class ImageSerializer
  include FastJsonapi::ObjectSerializer
  set_id { nil }
  attributes :image, :credit
end
