class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email, :api_key
end