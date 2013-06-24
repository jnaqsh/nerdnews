class ShareByMail
  # Rails4: just include ActiveModel::Model
  extend  ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend  ActsAsTextcaptcha::Textcaptcha
  acts_as_textcaptcha

  attr_accessor :name, :reciever, :body, :spam_answer, :spam_answers
  validates_presence_of :reciever, :name

  def initialize(user)
    @user = user
  end
  
  def persisted?
    false
  end

  def submit(params)
    self.name         = params[:name]
    self.reciever     = params[:reciever]
    self.body         = params[:body]
    self.spam_answer  = params[:spam_answer]
    self.spam_answers = params[:spam_answers]

    valid? ? true : false
  end

  def perform_textcaptcha?
    !skip_textcaptcha
  end
end