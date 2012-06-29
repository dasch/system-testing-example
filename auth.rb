require 'sinatra'

use Rack::Session::Cookie, {
  :key => 'tooters-paradise',
  :secret => 'trololol'
}

set :username, "herp"
set :password, "derp"

def authenticated?(username, password)
  username == settings.username && password == settings.password
end

get "/auth/sign_in" do
  if username = session[:username]
    erb :signed_in
  else
    @return_to = params[:return_to]
    erb :sign_in_form
  end
end

post "/auth/sign_in" do
  return_to = params[:return_to] || "/"

  if authenticated?(params[:username], params[:password])
    session[:username] = params[:username]
    redirect(return_to)
  else
    erb :invalid_credentials
  end
end

get "/auth/sign_out" do
  return_to = params[:return_to] || "/"
  session[:username] = nil
  redirect(return_to)
end

__END__

@@sign_in_form
<h2>Please sign in:</h2>
<form action="/auth/sign_in" method="post">
  <input type="hidden" name="return_to" value="<%= @return_to %>" />

  <p>
    <input type="text" name="username" placeholder="Username" />
  </p>

  <p>
    <input type="password" name="password" placeholder="Password" />
  </p>

  <p>
    <input type="submit" name="sign_in" value="Sign in" />
  </p>
</form>

@@invalid_credentials
<h2>Invalid username or password!</h2>
<p>
  <a href="/auth/sign_in">Go back</a>.
</p>
