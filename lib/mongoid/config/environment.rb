# encoding: utf-8
module Mongoid #:nodoc
  module Config

    # Encapsulates logic for getting environment information.
    module Environment
      extend self

      # Get the name of the environment that we are running under. This first
      # looks for Rails, then Sinatra, then a RACK_ENV environment variable,
      # and if none of those are found returns "development".
      #
      # @example Get the env name.
      #   Environment.env_name
      #
      # @return [ String ] The name of the current environment.
      #
      # @since 2.3.0
      def env_name
        return Rails.env if defined?(Rails)
        return Sinatra::Base.environment.to_s if defined?(Sinatra)
        ENV["RACK_ENV"] || ENV["MONGOID_ENV"] || raise(Errors::NoEnvironment.new)
      end

      # Load the yaml from the provided path and return the settings for the
      # current environment.
      #
      # @example Load the yaml.
      #   Environment.load_yaml("/work/mongoid.yml")
      #
      # @param [ String ] path The location of the file.
      #
      # @return [ Hash ] The settings.
      #
      # @since 2.3.0
      def load_yaml(path, environment = nil)
        env = environment ? environment.to_s : env_name
        YAML.load(ERB.new(File.new(path).read).result)[env]
      end
    end
  end
end
