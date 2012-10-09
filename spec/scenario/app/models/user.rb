class User < ActiveRecord::Base
  devise :cas_authenticatable, :rememberable

  def active_for_authentication?
    super && !deactivated
  end
end