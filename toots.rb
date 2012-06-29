require 'sinatra'

use Rack::Session::Cookie, {
  :key => 'tooters-paradise',
  :secret => 'trololol'
}

TOOTS = ["herp: hello!"]

get "/" do
  @toots = TOOTS
  erb :toots
end

post "/" do
  username = session[:username]

  if username.nil?
    redirect "/auth/sign_in", :redirect_to => "/"
  else
    toot = "#{username}: #{params[:toot]}"
    TOOTS.unshift(toot)
    redirect "/"
  end
end

__END__

@@toots
<form action="/" method="post">
  <p>
    <input type="text" name="toot" placeholder="Your toot here" />
  <p>

  <p>
    <input type="submit" value="Add toot!" />
  <p>
</form>

<ul>
  <% @toots.each do |toot| %>
  <li><%= toot %></li>
  <% end %>
</ul>
