if Rails.env.production?
  DelayedJobWeb.use Rack::Auth::Basic do |username, password|
    username == CONFIG[:delayed_job_username] && password == CONFIG[:delayed_job_password]
  end
end
