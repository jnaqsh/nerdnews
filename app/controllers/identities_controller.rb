class IdentitiesController < ApplicationController
  authorize_resource

  def index
    @identities = current_user.identities.order('provider asc')
  end

  def newaccount
    if params[:cancel]
      session[:authhash] = nil
      session[:service_id] = nil
      session.delete :authhash
      redirect_to root_url, flash: { error: t('controllers.identities.flash.canceled') }
    else  # create account
      @newuser = User.new
      @newuser.full_name = session[:authhash][:name]
      @newuser.email = session[:authhash][:email]
      @newuser.password = SecureRandom.uuid
      @newuser.identities.build(provider: session[:authhash][:provider], uid: session[:authhash][:uid])
      
      if @newuser.save!
        # signin existing user
        # in the session his user id and the service id used for signing in is stored
        cookies.permanent.signed[:permanent_user_id] = @newuser.id
        session[:service_id] = @newuser.identities.first.id
        redirect_to root_url, notice: t('controllers.identities.flash.created_successfully')
      else
        redirect_to root_url, notice: t('controllers.identities.flash.error_creating')
      end  
    end
  end

  # callback: success
  # This handles signing in and adding an authentication provider to existing accounts itself
  def create
    params[:provider] ? provider = params[:provider] : provider = 'No provider recognized (invalid callback)'
    omniauth = request.env['omniauth.auth']
    # raise omniauth.to_yaml
    @authhash = Hash.new

    if omniauth and params[:provider]
      if ['myopenid', 'google'].include? provider
        omniauth['info']['email'] ? @authhash[:email] =  omniauth['info']['email'] : @authhash[:email] = ''
        omniauth['info']['name'] ? @authhash[:name] =  omniauth['info']['name'] : @authhash[:name] = ''
        omniauth['uid'] ? @authhash[:uid] = omniauth['uid'].to_s : @authhash[:uid] = ''
        omniauth['provider'] ? @authhash[:provider] = omniauth['provider'] : @authhash[:provider] = ''
      end

      if @authhash[:uid].present? and @authhash[:provider].present?
        auth = Identity.find_by_provider_and_uid(@authhash[:provider], @authhash[:uid])

        # if the user is currently signed in, he/she might want to add another account to signin
        if current_user
          if auth
            redirect_to root_path, flash: { error: t('controllers.identities.flash.already_exist', provider: @authhash[:provider].capitalize) }
          else
            current_user.identities.create!(provider: @authhash[:provider], uid: @authhash[:uid])
            redirect_to identities_path, notice: t('controllers.identities.flash.added_successfully', provider: @authhash[:provider].capitalize)
          end
        else
          if auth
            # signin existing user
            # in the session his user id and the service id used for signing in is stored
            cookies.permanent.signed[:permanent_user_id] = auth.user.id
            session[:service_id] = auth.id
            redirect_to root_url, notice: t('controllers.identities.flash.signedin_successfully', provider: @authhash[:provider].capitalize)
          else
            # this is a new user; show signup; @authhash is available to the view and stored in the sesssion for creation of a new user
            session[:authhash] = @authhash
            render signup_identities_path
          end
        end
      else
        redirect_to root_path, flash: { error: t('controllers.identities.flash.authenticating_error', provider: @authhash[:provider].capitalize) }
      end
    else 
      redirect_to root_path, flash: { error: t('controllers.identities.flash.authenticating_error', provider: @authhash[:provider].capitalize) }
    end
  end

  def destroy
    # remove an authentication service linked to the current user
    @identity = current_user.identities.find(params[:id])
    
    if session[:service_id] == @identity.id
      flash[:error] = t('controllers.identities.flash.signin_error')
    else
      @identity.destroy
    end
    redirect_to identities_path, notice: t('controllers.identities.flash.successfully_removed')
  end

  # callback: failure
  def failure
    redirect_to root_url, flash: { error: t('controllers.identities.flash.notloggedin') }
  end
end
