class ShareByMail
  # Rails4: just include ActiveModel::Model
  extend  ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend  ActsAsTextcaptcha::Textcaptcha
  acts_as_textcaptcha

  attr_accessor :name, :reciever, :body, :spam_answer, :spam_answers
  validates_presence_of :reciever, :name

  def initialize(user, args = {})
    @user = user
    if !args.empty?
      self.name          = args[:name]
      self.reciever      = args[:reciever]
      self.body          = args[:body]
      self.spam_answer   = args[:spam_answer]
      self.spam_answers  = args[:spam_answers]
    end
  end
  
  def persisted?
    false
  end

  def submit
    # raise
    if valid?
      true
    else
      false
    end
  end

  def perform_textcaptcha?
    !skip_textcaptcha
  end
end