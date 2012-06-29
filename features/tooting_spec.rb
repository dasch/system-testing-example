$foreman = Process.fork do
  # Redirect the Foreman output to foreman.log
  $stdout.reopen("foreman.log", "a")

  exec("foreman start")
  exit! 127
end

END {
  if $foreman
    # Make sure we shut down Foreman once we're done.
    Process.kill("INT", $foreman)
    Process.waitpid($foreman)
  end
}

require 'capybara/rspec'
require 'capybara/poltergeist'

Capybara.app_host = "http://localhost:9000"
Capybara.current_driver = :poltergeist

feature "Tooting" do
  scenario "Unauthenticated user submits a toot" do
    visit "/"
    fill_in "toot", :with => "ZOMG TOOTS"
    click_button "Add toot!"

    page.should have_content("Please sign in")

    fill_in "username", :with => "herp"
    fill_in "password", :with => "derp"

    click_button "Sign in"

    fill_in "toot", :with => "ZOMG TOOTS"
    click_button "Add toot!"

    page.should have_content("herp: ZOMG TOOTS")
  end
end
