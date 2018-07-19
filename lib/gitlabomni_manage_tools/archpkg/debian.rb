# frozen_string_literal: true

module GitLabOmnibusManage
  module ArchPkg
    module DebianUtil
      module_function

      def apt_current_version(pkg)
        status = Hash[*`dpkg --status #{pkg}`
          .split(/\r?\n/)
          .flat_map { |line| line.split(': ', 2) }
        ]

        status['Version'].sub('-', '+')
      end

      def apt_available_version(pkg)
        status = Hash[*`apt-cache --quiet=0 show #{pkg}`
          .split(/\r?\n/)
          .slice_before(/^$/).first
          .flat_map { |line| line.split(': ', 2) }
        ]

        status['Version'].sub('-', '+')
      end
    end

    module Debian
      PKG_NAME = 'gitlab-ce'

      module_function

      def current_version
        DebianUtil.apt_current_version(PKG_NAME)
      end

      def available_version
        DebianUtil.apt_available_version(PKG_NAME)
      end

      def update_index_command(options = {})
        update_args = []

        if options[:quiet]
          update_args.push('-qq')
        end

        <<~COMMAND
          apt-get update #{update_args.join(' ')}
        COMMAND
          .strip
      end

      def upgrade_command(options = {})
        upgrade_args = []

        if options[:quiet]
          upgrade_args.push('-qq')
        end

        upgrade_args.push('-y') if options[:yes]

        <<~COMMAND
          apt-get install #{upgrade_args.join(' ')} gitlab-ce
        COMMAND
          .strip
      end
    end

    module_function

    def debian
      Debian
    end
  end
end
