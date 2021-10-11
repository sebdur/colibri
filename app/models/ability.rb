# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
      cannot [:create], Order
    else
      can [:index, :create], Order, :user_id => user.id
      can [:destroy], Order.where(payed: false), :user_id => user.id
      can [:show, :create], Payment, :user_id => user.id
    end
  end
end
