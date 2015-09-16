**beertrade** is an app used by the /r/beertrade reddit community to keep track of beer trades and the corresponding reputation and flair for users.  

--- 

### Contributing
1. Fork this repository 
2. [Contact the moderators](https://www.reddit.com/message/compose?to=%2Fr%2Fbeertrade&subject=&message=) to request the necessary service credentials
3. Set up your `.env` file:
```bash
RACK_ENV=development
PORT=3000
REDDIT_OAUTH_ID=...
REDDIT_OAUTH_SECRET=...
BOT_OAUTH_ID=...
BOT_OAUTH_SECRET=...
BOT_USERNAME=...
BOT_PASSWORD=...
```
4. Run:
```bash
gem install foreman
bundle install
rake db:migrate
foreman s
```
5. Send feature in a pull request for review and merging
