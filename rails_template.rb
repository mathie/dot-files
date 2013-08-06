# This is my default template for starting new Rails apps. There are many like
# it, but this one is mine.

# Couple of helper functions to dry up some patterns
def commit_with_message(message)
  yield if block_given?
  git add: '.'
  git commit: "-m '#{message} (rails template).'"
end

$sed_patterns = {
  remove_comments: '/^ *#/d',
  remove_production_database_stanza: '/^production:/,$d',
  remove_duplicate_newlines: '/^$/N;/\n$/D'
}

def sed(file, *patterns)
  sed_commands = patterns.map do |pattern|
    pattern = $sed_patterns[pattern] if pattern.is_a? Symbol

    # Ahh, shell quoting. Life's too short.
    if pattern.index("'")
      %Q{sed -e "#{pattern}"}
    else
      %Q{sed -e '#{pattern}'}
    end
  end.join(' | ')

  run %Q{cat #{file} | #{sed_commands} > #{file}.tmp; mv #{file}.tmp #{file}}
end

def insert_at_top(file, text)
  File.open(file, 'r+') do |f|
    content = f.read
    f.rewind
    f.write text
    f.puts
    f.write content
  end
end

def insert_before(file, pattern, text)
  content = ''
  File.open(file, 'r+') do |f|
    while (line = f.readline) !~ pattern do
      content << line
    end
    content << text
    content << line
    content << f.read

    f.rewind
    f.write content
  end
end

# Initialise git and create the first commit as a pure skeleton.
git :init
git add: '.'
commit_with_message 'Initial commit'

commit_with_message 'Initial gem versions' do
  file '.ruby-version', '2.0.0'
  sed 'Gemfile', :remove_comments, "s/gem 'rails.*$/gem 'rails', '~> 4.0.0'/", :remove_duplicate_newlines
  run 'bundle install'
end

commit_with_message 'Setup database' do
  run "createuser -s #{app_name}"
  sed 'config/database.yml', :remove_comments, :remove_production_database_stanza, :remove_duplicate_newlines
  rake 'db:create:all'
  rake 'db:migrate'
end

commit_with_message 'Tidy up configuration and remove boilerplate' do
  sed 'config/application.rb', :remove_comments, :remove_duplicate_newlines
  environment "config.timezone = 'London'"
  git rm: '-rf README.rdoc config/initializers/{backtrace_silencers,inflections,mime_types}.rb config/locales/en.yml'
  file 'README.markdown', <<-README
# #{app_name.humanize}

TODO: Insert some real documentation on getting started with development.
  README
end

commit_with_message 'rspec for testing' do
  gem_group :development, :test do
    gem 'rspec-rails'
  end
  run 'bundle install'

  generate 'rspec:install'
end

commit_with_message 'puma app server' do
  gem 'puma'
  run 'bundle install'

  initializer 'database_connection.rb', <<-RUBY
# Taken from https://devcenter.heroku.com/articles/concurrency-and-database-connections
Rails.application.config.after_initialize do
  ActiveRecord::Base.connection_pool.disconnect!

  ActiveSupport.on_load(:active_record) do
    config = Rails.application.config.database_configuration[Rails.env]
    config['reaping_frequency'] = ENV['DB_REAP_FREQ'] || 10 # seconds
    config['pool']              = ENV['DB_POOL'] || 5
    ActiveRecord::Base.establish_connection(config)
  end
end
  RUBY

  file 'Procfile', <<-PROCFILE
web: bundle exec puma -t 0:5 -p $PORT -e ${RACK_ENV:-development}
  PROCFILE

  insert_at_top 'config/application.rb', <<-RUBY
# Force stdio to be unbuffered, even when the controlling tty isn't a terminal.
# This means that logs show up immediately in foreman's output.
$stdout.sync = true
$stderr.sync = true
  RUBY
end

commit_with_message 'Additional development helper gems' do
  gem_group :development do
    gem 'pry-rails'
    gem 'awesome_print', require: false
    gem 'meta_request'
  end
  run 'bundle install'
end

commit_with_message 'Static home page' do
  generate :controller, 'pages', 'index'
  sed 'config/routes.rb', :remove_comments, :remove_duplicate_newlines
  route "root to: 'pages#index'"
end

commit_with_message 'Guard for running tests' do
  gem_group :development, :test do
    gem 'guard-bundler', require: false
    gem 'guard-rspec', require: false
  end

  run 'bundle install'
  file 'Guardfile', <<-RUBY
notification :tmux,
  :display_message => true,
  :line_separator  => ' | ',
  :color_location  => 'status-left-fg',
  :timeout         => 2
  RUBY
  run 'bundle exec guard init bundler'
  run 'bundle exec guard init rspec'
end

commit_with_message 'UI Framework with Bootstrap' do
  gem 'bootstrap-sass'
  run 'bundle install'

  file 'app/assets/stylesheets/bootstrap_config.css.scss', <<-CSS
// Override bootstrap variables before including bootstrap itself.

// Now include bootstrap
@import "bootstrap";
@import "bootstrap-responsive";
  CSS

  file 'app/views/layouts/application.html.erb', <<-HTML, force: true
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%= tag :link, { rel: 'shortcut icon', href: image_path('favicon.ico') }, true %>

    <%= stylesheet_link_tag "application" %>

    <title><%= content_for?(:title) ? "\#{yield :title} - " : "" %>#{app_name}</title>
  </head>
  <body>
    <% if content_for?(:title) %>
      <hgroup class="container">
        <h1><%= yield :title %></h1>
      </hgroup>
    <% end %>

    <article id="main" role="main" class="container">
      <section id="flash" class="container">
        <% if notice.present? %>
          <div class="alert alert-success">
            <a href="#" class="close" data-dismiss="alert">x</a>
            <%= notice.html_safe %>
          </div>
        <% end %>
        <% if alert.present? %>
          <div class="alert alert-error">
            <a href="#" class="close" data-dismiss="alert">x</a>
            <%= alert.html_safe %>
          </div>
        <% end %>
      </section>

      <section id="content" class="container">
        <%= yield %>
      </section>
    </article>

    <%= javascript_include_tag "application" %>
  </body>
</html>
  HTML

  insert_before 'app/assets/javascripts/application.js', /require jquery_ujs/, <<-JS
//= require bootstrap
  JS
end
