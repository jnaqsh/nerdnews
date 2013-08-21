class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.role? :founder
     founder_user_permissions(user)
    elsif user.role? :approved
     approved_user_permissions(user)
    elsif user.role? :new_user
     new_user_permissions(user)
    else # guest user
     guest_user_permissions
    end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end

  private

  def guest_user_permissions
    # Comment model
    can :create, Comment

    # Announcement model
    can :hide, Announcement

    # Identity model
    can [:create, :failure], Identity

    # Page model
    can :show, Page

    # sessions controller
    can [:new, :create], :session

    # Story model
    can [:read, :create, :recent], Story
    cannot :show, Story, publish_date: nil

    # Tag model
    can :index, Tag

    # User model
    can [:create, :show, :posts, :comments, :favorites], User
    cannot :bypass_captcha, User
  end

  def new_user_permissions(user)
    # a new user can do anything a guest user can
    guest_user_permissions

    # ActivityLog model
    can :index, ActivityLog

    # Comment model
    can [:update, :destroy], Comment, user: {id: user.id}

    # Identity model
    can [:index, :destroy], Identity, user: {id: user.id}

    # Message model
    can [:index, :destroy], Message, receiver: { :id => user.id }
    can [:index, :create], Message, sender: { :id => user.id }
    cannot :create, Message, receiver: { :id => user.id }

    # mypage controller
    can :index, :mypage

    # sessions controller
    can :destroy, :session
    cannot [:new, :create], :session

    # Story model
    can :unpublished, Story
    can :update, Story, user: {id: user.id}

    # User model
    can [:update, :add_to_favorites, :activity_logs], user
    can :bypass_captcha, user

    # Vote model
    can :create, Vote
  end

  def approved_user_permissions(user)
    # an approved user can do anything a new_user can
    new_user_permissions(user)

    # Story model
    can :publish, Story

    # Tag model
    can [:create, :update], Tag
  end

  def founder_user_permissions(user)
    # a founder user can do anything a approved_user can
    approved_user_permissions(user)

    # ActivityLog model
    can :show, ActivityLog

    # Announcement model
    can :manage, Announcement

    # Comment model
    can :manage, Comment

    # Page model
    can :manage, Page

    # Rating model
    can :manage, Rating

    # Story model
    can :manage, Story

    # Role model
    can :manage, Role

    # Tag model
    can :manage, Tag

    # User model
    can :manage, User
  end
end
