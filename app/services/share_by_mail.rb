class ShareByMail
  # Rails4: just include ActiveModel::Model
  extend  ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :name, :reciever, :body
  validates_presence_of :reciever, :name

  def initialize(user)
    @user = user
  end
  
  def persisted?
    false
  end

  def submit(params)
    self.name     = params[:name]
    self.reciever = params[:reciever]
    self.body     = params[:body]

    valid? ? true : false
  end
end