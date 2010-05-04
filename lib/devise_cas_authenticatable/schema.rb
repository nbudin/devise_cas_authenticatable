Devise::Schema.class_eval do
  def cas_authenticatable
    apply_schema :username, String
  end
end