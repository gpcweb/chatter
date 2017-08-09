# Chatter

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

# Production

The master branch is configured to run production on heroku, if you want to deploy to an amazon ec2 please checkout the branch 'add-distillery-config', with the current config you dont need to install erlang and elixir on your production machine. It's important that system enviroment variables must be declared on your BUILD machine (because they are need it when you compile), and that your build machine has to be the same OS that your production machine.

I'm using nginx as reverse proxy to serve my phoenix app and this is my chatter.conf file under `/etc/nginx/sites-availables`, remember that this file must be copied to `/etc/nginx/sites-enabled` as a symbolic link, and that you need to run `sudo service nginx reload`:

```
  upstream hello_phoenix {
    server 127.0.0.1:4001;
  }

  map $http_upgrade $connection_upgrade {
    default upgrade;
    '' close;
  }

 server{
   listen 80;
   server_name chatter.cl;

   location / {
     try_files $uri @proxy;
   }

   location @proxy {
     include proxy_params;
     proxy_redirect off;
     proxy_pass http://hello_phoenix;
     proxy_set_header Upgrade $http_upgrade;
     proxy_set_header Connection $connection_upgrade;
   }
 }
 ```

Now we need to make some configurations before deploy our app:

  * First on your build machine set this enviroment variables
   * DATABASE_NAME
   * DATABASE_HOST
   * DATABASE_USERNAME
   * DATABASE_PASSWORD
   * API_KEY (I'm using sengrid to send coherence email, so this is the sendgrid api_key)
   * SECRET_KEY_BASE (Just run `mix phoenix.gen.secret)
  * Then you need to build the release with
   * `./node_modules/brunch/bin/brunch b -p && MIX_ENV=prod mix do phoenix.digest, release --env=prod`
  * Your release will be placed on
   * `_build/prod/rel/chatter/releases/0.0.1/chatter.tar.gz` 
  * Now you must copy the chatter.tar.gz file to your production machine with (replace this 127.0.0.1 address with yours):
   * `scp chatter.tar.gz deploy@127.0.0.1:/home/your_user/production.chatter.cl/`
  * Now log in on your production machine and decompress the tar.gz file like this
   * `cd production.chatter.cl`
   * `tar xzf chatter.tar.gz`
  * Finally you can check your release with
   * ` ./bin/chatter foreground`
  * If everything is ok you will see some logs to shut it down just press ctrl + c
  * Now just hit `./bin/chatter start` and this will start your phoenix app on http://localhost:4001

# Update Production

Master branch has been updated to use distillery and edeliver. To use edeliver you must provide on your build machine all the enviroment variables described before (we asume that the enviroment variables from your build machine apply to your production machine, database_host, database_name, secret, etc) and install this depedencies:

  * Update/install node and npm to the last version available
   * `sudo apt-get install node`
   * `sudo apt-get install npm`
  * Install git
   * `sudo apt-get -y install git`
  * Add erlang solutions repo
   * `wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb`
  * Update ubuntu
   * `sudo apt-get update`
  * Install erlang
   * `sudo apt-get install esl-erlang`
  * Install elixir
   * `sudo apt-get install elixir`
  * Install hex
   * `mix local.hex`
  * Install phoenix
  * `mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez`

Ready to go?

The first step is to instruct edeliver to build our release on our build host:
 * `mix edeliver build release`

Next, let’s push our initial release up to our production server:
 * `mix edeliver deploy release to production`

Now let’s fire up the Phoenix application in production:
 * `mix edeliver start production`

We can check that everything went well by using edeliver to ping our application:
 * `mix edeliver ping production`

If our application is up and running, we should receive a pong reply to our ping.

# Update production configuration

Now the app was updated to deploy to more than one server, you only need to add the new ip or domain to the PRODUCTION_HOSTS variable on .deliver/config file.

Also the it was updated to connect nodes, you only have to configure two files on each production machine:

Configuration of node1 vm.args
`
-name node1@1.1.1.1
-setcookie your_secret
-kernel inet_dist_listen_min 9100 inet_dist_listen_max 9155
-config /home/deploy/app.config
`

Configuration of node1 app.config
`
[{kernel,
  [
    {sync_nodes_optional, ['node2@1.1.1.2']},
    {sync_nodes_timeout, 30000}
  ]}
].
`

Its very important that node1 needs to be aware of node2 and viceversa on the app.config file, each file must live on /home/your_user/ folder unless you declare something different on .deliver/config LINK_VM_ARGS variable.

Finally on each machine security group you have to open the port 4369 and from 9100 to 9155.

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
