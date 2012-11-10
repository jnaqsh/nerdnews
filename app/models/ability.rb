class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
       user ||= User.new # guest user (not logged in)
       if user.role? :founder
         can :manage, :all
       elsif user.role? :approved
         can :manage, Comment
         can [:create, :failure], Identity
         can [:index, :destroy], Identity, user: { :id => user.id }
         can :manage, Message, user: { :id => user.id }
         can :show, Message, reciver_id: user.id
         can [:index, :show], Page
         can :manage, Story
         can :manage, Tag
         can [:create, :show, :posts, :comments, :favorites], User
         can [:edit, :update], User, :id => user.id
         can :create, Vote
         can :index, :mypage
         can :destroy, :session
         can :manage, :password_reset
       elsif user.role? :new_user
         can :create, Comment
         can [:create, :failure], Identity
         can [:index, :destroy], Identity, user: { :id => user.id }
         can :manage, Message, user: { :id => user.id }
         can :show, Message, reciver_id: user.id
         can :show, Page
         can [:read, :create], Story
         can :index, Tag
         can [:create, :show, :posts, :comments, :favorites], User
         can [:edit, :update], User, :id => user.id
         can :create, Vote
         can :index, :mypage
         can :destroy, :session
         can :manage, :password_reset
       else # guest user
         can :create, Comment
         can [:read, :create], Story
         can [:create, :show, :posts, :comments, :favorites], User
         can [:edit, :update], User, :id => user.id
         can [:create, :failure], Identity
         can [:index, :destroy], Identity, user: { :id => user.id }
         can :manage, Message, user: { :id => user.id }
         can :show, Message, reciver_id: user.id
         can :index, Tag
         can :show, Page
         can :manage, :password_reset
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
