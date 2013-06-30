[![Build Status](https://travis-ci.org/elim/capistrano-demand_forward_agent.png)](https://travis-ci.org/elim/capistrano-demand_forward_agent)

Capistrano::DemandForwardAgent
==============================

Demand forward-agent on deploying.

- Confirming agent connection.
- Confirming identity status.

Unless satisfied then raise exception.


Installation
------------

Add this line to your application's Gemfile:

    gem 'capistrano-demand_forward_agent'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-demand_forward_agent


Usage
-----

Put the following to your `deploy.rb`.

    require 'capistrano/demand_forward_agent'

    demand_forward_agent.confirm


Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
