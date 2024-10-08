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

# Starting the server
- `cd config && rackup config.ru -p 9292` or just `cd config && rackup`

# Starting the server as a service
1. Create service file `/etc/systemd/system/office.service` (assuming your project folder is on this path `/home/office/www/office` and your linux user name is `office`.
```
[Unit]
Description=Office Script

[Service]
ExecStart=/home/office/.rbenv/shims/rackup /home/office/www/office/config/config.ru -p 9292
Restart=always
User=office
WorkingDirectory=/home/office/www/office/config/
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=office_script

[Install]
WantedBy=multi-user.target
```
2. Enable office service `sudo systemctl enable office.service`
3. Start the service `sudo systemctl start office.service`

# Roadmap
- [ ] **Style Coffee Status:** Implement styling on the coffee index page to indicate Google Chat API success or failure (e.g., green for success, red for failure).
- [ ] **Use ChatGPT for Notifications:** Integrate ChatGPT to generate notification messages, potentially as a third button option.
- [ ] **Text Field for Context:** Add a text field for each status, allowing visitors to provide context for ChatGPT to create personalized notification messages.
- [ ] **Set Up CI with GitHub Actions:** Implement continuous integration (CI) using GitHub Actions to automate testing and deployment.
- [x] **Rate Limiting for Notifications:** Implement rate limiting to control the frequency of chat notifications and reduce the risk of abuse. This can involve setting limits on the number of notifications sent per user or IP address within a specific time frame.
- [x] **Visitor Name Input:** Add a feature where visitors can enter their name in English. This name will be included in the chat message to personalize notifications.

# Contribution guide
Your contributions are greatly appreciated. Please follow the guidelines below to ensure a smooth and efficient collaboration.
1. Adding New Routes:
   - Modify `router.rb`:
   Add your new routes by modifying the `handle_request` method in the `router.rb` file.
   - Follow the existing pattern for defining routes and ensure that each route is clearly documented within the code.
1. Creating Helper Functions:
   - If your route requires additional functionality, create helper functions in the `config/app.rb` file.
   - Maintain consistent coding style with the rest of the codebase.
   - Follow best practices for Ruby development.
1. Submitting Your Contribution
   - Fork the repository and create a feature branch.
   - Submit a pull request with a clear description.
   - Be prepared to respond to any feedback or questions from the maintainers. And make any requested changes promptly.
1. Guidelines:
   - **Keep It Simple:** Aim for simplicity and clarity in your contributions.
   - **Think of the Next Maintainer:** Ensure your code is well-documented and organized to help the next developer working on your changes.
   - **Stay Updated:** Keep your fork up-to-date with the latest changes from the main repository to avoid merge conflicts.

Thank you for contributing! We look forward to your improvements and ideas.
