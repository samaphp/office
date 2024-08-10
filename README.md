# Office
This open-source Ruby script, crafted with the assistance of ChatGPT, brings automated reminders and playful interactions to your Google Chat space. The project is built with clean and accessible Ruby syntax. Whether you're interested in developing new features or refining existing ones, this collaborative project welcomes developers of all skill levels. Join us in making Google Chat more engaging and efficient!

# Features
- **Open-source project** with clean Ruby syntax for easy collaboration.
- **Developed with ChatGPT's assistance** for innovative solutions.
- **Welcome to contribute** by expanding features and improving functionality through PRs.

# Installation
- Install `curl git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev`
- `git clone https://github.com/rbenv/rbenv.git ~/.rbenv`
- `echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc`
- `echo 'eval "$(rbenv init -)"' >> ~/.bashrc`
- `exec $SHELL`
- `git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build`
- `echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc`
- `exec $SHELL`
- `rbenv install 3.2.2`
- `rbenv global 3.2.2`
- Install Rack web server `gem install rack`
- Start the server: `cd config && rackup config.ru -p 9292`
