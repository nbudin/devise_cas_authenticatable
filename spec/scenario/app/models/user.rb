class User < ActiveRecord::Base
  devise :bushido_authenticatable, :rememberable
end
