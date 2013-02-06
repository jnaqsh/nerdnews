# This line will initialize a scheduler to remove 
# under_construction configs after running your server

Rails.application.config.after_initialize do
  UnderConstruction::Schedule.new
end
