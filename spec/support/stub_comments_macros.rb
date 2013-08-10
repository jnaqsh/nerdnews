module StubCommentsMacros
  def stub_akismet_connection
    # Set user ip, user agent and referer for Capybara
    page.driver.options[:headers] = {'REMOTE_ADDR' => '1.2.3.4', 'HTTP_USER_AGENT' => 'RailsApp/NerdNews', 'HTTP_REFERER' => 'http://localhost'}

    # Stub request to akismet
    stub_request(:post, /.*akismet.com\/.*/)
      .to_return(status: 200, body: "false", headers: {'Content-Length'=> 4 })
  end

  def stub_akismet_connection_for_spam
    # Set user ip, user agent and referer for Capybara
    page.driver.options[:headers] = {'REMOTE_ADDR' => '1.2.3.4', 'HTTP_USER_AGENT' => 'RailsApp/NerdNews', 'HTTP_REFERER' => 'http://localhost'}

    stub_request(:post, /.*akismet.com\/.*/)
      .with(body: hash_including({ "comment_author" => "viagra-test-123" }))
      .to_return(status: 200, body: "true", headers: {'Content-Length'=> 4 })
  end
end
