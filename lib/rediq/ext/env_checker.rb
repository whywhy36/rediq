require 'facter'

module Rediq
  module EnvChecker
    class << self
      def init
        Facter.loadfacts
      end

      def processor_count
        Facter.processorcount.nil? ? nil : Facter.processorcount.to_i
      end

    end
  end
end