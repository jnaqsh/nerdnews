class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
       user ||= User.new # guest user (not logged in)
       if user.role? :founder
         can :manage, Comment
         can [:create, :failure], Identity
         can [:index, :destroy], Identity, user: { :id => user.id }
         can [:index, :destroy], Message, receiver: { :id => user.id }
         can [:index, :create], Message, sender: { :id => user.id }
         cannot :create, Message, receiver: { :id => user.id }
         can :index, :mypage
         can :manage, Page
         can :manage, Rating
         can :destroy, :session
         can :manage, Story
         can :manage, Role
         can :manage, Tag
         can :manage, User
         can :create, Vote
         can :bypass_captcha, user
         can :add_to_favorites, User
         can [:show, :index], ActivityLog
       elsif user.role? :approved
         can :index, ActivityLog
         can :create, Comment
         can [:update, :destroy], Comment, user: {id: user.id}
         can [:create, :failure], Identity
         can [:index, :destroy], Identity, user: { :id => user.id }
         can [:index, :destroy], Message, receiver: { :id => user.id }
         can [:index, :create], Message, sender: { :id => user.id }
         cannot :create, Message, receiver: { :id => user.id }
         can :index, :mypage
         can :show, Page
         can :destroy, :session
         can [:read, :create, :publish, :unpublished, :recent], Story
         can [:update, :destroy], Story, user: {id: user.id}
         can [:read, :create, :update], Tag
         can [:show, :posts, :comments, :favorites], User
         can :activity_logs, User, id: user.id
         can :update, User, :id => user.id
         can :bypass_captcha, user
         can :add_to_favorites, User
         can :create, Vote
       elsif user.role? :new_user
         can :index, ActivityLog
         can :create, Comment
         can [:update, :destroy], Comment, user: {id: user.id}
         can [:create, :failure], Identity
         can [:index, :destroy], Identity, user: { :id => user.id }
         can [:index, :destroy], Message, receiver: { :id => user.id }
         can [:index, :create], Message, sender: { :id => user.id }
         cannot :create, Message, receiver: { :id => user.id }
         can :index, :mypage
         can :show, Page
         can :destroy, :session
         can [:read, :create, :recent], Story
         can [:update, :destroy], Story, user: {id: user.id}
         can :index, Tag
         can [:show, :posts, :comments, :favorites], User
         can :activity_logs, User, id: user.id
         can :update, User, :id => user.id
         cannot :bypass_captcha, user
         can :add_to_favorites, User
         can :create, Vote
       else # guest user
         can :create, Comment
         can [:create, :failure], Identity
         can :show, Page
         can [:new, :create], :session
         can [:read, :create, :recent], Story
         can :index, Tag
         can [:create, :show, :posts, :comments, :favorites], User
         cannot :bypass_captcha, User
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
end
