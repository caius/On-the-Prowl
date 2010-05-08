# On the Prowl

Script that listens for DMs from a twitter account, acts upon any DMs received (from certain users) and prowls a response. (Push notification to iPhone.)

## Installation

Pretty testless, written in a way that it works for me (so far.)

Installation should be something along the lines of:

1. copy config.yml.sample to config.yml
2. Register [prowl][] account
3. Enter prowl api key in config.yml
4. Register a [twitter oauth][] application
5. Enter the oauth app consumer key (`token`) and `secret` in config.yml
6. run `rake twitter:authorize` and follow the instructions
7. Verify `atoken` and `asecret` have appeared in config.yml
8. `ruby main.rb`
9. ???
10. Beer

[prowl]: http://prowl.weks.net/
[twitter oauth]: http://twitter.com/apps/new
