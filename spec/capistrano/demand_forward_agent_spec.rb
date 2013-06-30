# -*- coding: utf-8 -*-
require 'spec_helper'
require 'capistrano'
require 'capistrano/ssh'

describe Capistrano::DemandForwardAgent do

  before :all do
    class Container
      include Capistrano::DemandForwardAgent
      attr_accessor :ssh_options

      def initialize
        @ssh_options = {}
      end
    end

    @container = Container.new
  end

  before do
    Net::SSH::Authentication::Agent.stub(:connect) do
      Net::SSH::Authentication::Agent.new
    end

    Net::SSH::Authentication::Agent.any_instance.stub(:identities) do
      [1]
    end
  end

  describe 'version number' do
    it do
      Capistrano::DemandForwardAgent::VERSION.should_not be_nil
    end
  end

  describe '#confirm' do
    it do
      @container.should_receive(:set_ssh_option).once
      @container.should_receive(:connect_agent).once
      @container.should_receive(:confirm_identity).once
      @container.confirm
    end
  end

  describe '#set_ssh_option' do
    context 'ssh_options[:forward_agent] = true' do
      before do
        @container.ssh_options[:forward_agent] = true
      end

      it do
        expect(@container.set_ssh_option).to be_true
      end
    end

    context 'ssh_options[:forward_agent] = false' do
      before do
        @container.ssh_options[:forward_agent] = false
      end

      it do
        expect(@container.set_ssh_option).to be_true
      end
    end

    context 'unset ssh_options[:forward_agent]' do
      it do
        expect(@container.set_ssh_option).to be_true
      end
    end
  end

  describe '#connect_agent' do
    context 'when ssh-agent running' do
      it do
        expect(@container.connect_agent).to be_instance_of Net::SSH::Authentication::Agent
      end
    end

    context 'when ssh-agent is stopped' do
      before do
        Net::SSH::Authentication::Agent.stub(:connect) do
          raise Net::SSH::Authentication::AgentNotAvailable
        end
      end

      it do
        expect do
          @container.connect_agent
        end.to raise_error Capistrano::DemandForwardAgent::SSHAgentError
      end
    end
  end

  describe '#confirm_identity' do
    context 'when there is one identify' do
      before do
        @agent = @container.connect_agent
        Net::SSH::Authentication::Agent.any_instance.stub(:identities) do
          [1]
        end
      end

      it do
        expect(@container.confirm_identity(@agent)).to be_true
      end
    end

    context 'when there is no identify' do
      before do
        @agent = @container.connect_agent
        Net::SSH::Authentication::Agent.any_instance.stub(:identities) do
          []
        end
      end

      it do
        expect {@container.confirm_identity(@agent)}.to raise_error Capistrano::DemandForwardAgent::SSHIdentityError
      end
    end
  end
end
