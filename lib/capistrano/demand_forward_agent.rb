require 'capistrano/demand_forward_agent/version'
require 'capistrano'
require 'net/ssh'

module Capistrano
  module DemandForwardAgent
    extend self
    include Net::SSH::Authentication

    SSHAgentError    = Class.new Capistrano::Error
    SSHIdentityError = Class.new Capistrano::Error

    def confirm
      set_ssh_option
      agent = connect_agent
      confirm_identity agent
    end

    def set_ssh_option
      ssh_options[:forward_agent] = true
    end

    def connect_agent
      begin
        agent = Agent.connect
      rescue AgentNotAvailable
        raise SSHAgentError.new 'Please run the `eval $(ssh-agent)` first.'
      end

      agent
    end

    def confirm_identity agent
      if agent.identities.length == 0
        raise SSHIdentityError.new 'Please run the `ssh-add` first.'
      end

      true
    end

  end
end

Capistrano.plugin :demand_forward_agent, Capistrano::DemandForwardAgent

