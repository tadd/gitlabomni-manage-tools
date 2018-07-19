# frozen_string_literal: true

require 'thor'

require_relative 'util/archpkg'
require_relative 'config'

Dir.glob(
  File.expand_path('commands/*.rb', __dir__)
).each do |entry|
  require_relative entry
end

module GitLabOmnibusManage
  class Command < Thor
    def initialize(args, opts, config)
      super(args, opts, config)

      @pkg = config[:package] || Util.gitlabpkg
      @config = Config.load(options['config'])
    end

    class_option :config, type: :string,
      banner: 'CONFIG', aliases: [:c],
      desc: 'use as global configuration'

    desc 'current-version', 'get current version'
    def current_version
      puts @pkg.current_version
    end

    desc 'available-version', 'get available version'
    def available_version
      puts @pkg.available_version
    end

    include GitLabOmnibusManage::SubCommands

    desc 'check', 'check updates'
    def check
      command_check
    end

    desc 'diff [options]', 'different from available'
    method_option :url, type: :boolean, default: false,
      desc: 'show URL based difference'
    def diff
      command_diff
    end

    desc 'show-template [options]', 'show template'
    method_option :available, type: :boolean, default: false,
      desc: 'show template of available version'
    def show_template
      command_show_template
    end

    desc 'update [options]', 'update gitlab package (deplicated. Use `upgrade`)'
    method_option :yes, type: :boolean, default: false,
      aliases: [:y], desc: 'force updating'
    method_option :quiet, type: :boolean, default: false,
      aliases: [:q], desc: 'quiet updating'
    def update
      STDERR.puts 'Use `upgrade` instead of `update`.'
      command_upgrade
    end

    desc 'upgrade [options]', 'upgrade gitlab package'
    method_option :yes, type: :boolean, default: false,
      aliases: [:y], desc: 'force upgrading'
    method_option :quiet, type: :boolean, default: false,
      aliases: [:q], desc: 'quiet upgrading'
    def upgrade
      command_upgrade
    end

    desc 'update-index [options]', 'update package index'
    method_option :quiet, type: :boolean, default: false,
      aliases: [:q], desc: 'quiet updating'
    def update_index
      command_update_index
    end

    desc 'notify-cronjob [options]', 'notify cron job command'
    method_option :mailto, type: :string,
      desc: 'address for mail to'
    method_option :force, type: :boolean, default: false,
      aliases: [:f], desc: 'force notification'
    def notify_cronjob
      command_notify_cronjob
    end

    desc 'backup [options]', 'backup command'
    def backup
      command_backup
    end
  end
end
