class User < ActiveRecord::Base
  devise :cas_authenticatable, :rememberable, :timeoutable, :trackable

  def active_for_authentication?
    super && !deactivated
  end
end