class User < ApplicationRecord
  has_many :orders  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_initialize do
    if self.new_record?
      self.role ||= :user
    end
  end

  enum role: [:user, :admin]

end
