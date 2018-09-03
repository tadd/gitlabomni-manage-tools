# frozen_string_literal: true

require 'yaml'
require 'socket'

require_relative 'util/base'

module GitLabOmnibusManage
  class Config
    class << self
      def load(path)
        config_obj = {}

        if path.nil?
          paths = default_paths
          config_obj = YAML.load_file(paths[0]) if paths.size.positive?
        else
          config_obj = YAML.load_file(path)
        end

        Config.new(config_obj)
      end

      def default_paths
        [
          '/etc/gitlab-manage/config.yaml',
          'config.yaml'
        ].select { |path| File.exist?(path) }
      end

      def default_config
        hostname = Util.hostfullname

        {
          'general' => {
            'data_dir' => '/var/lib/gitlab-manage/data',
            'cache_dir' => '/var/lib/gitlab-manage/cache'
          },
          'mail' => {
            'enable' => false,
            'host' => 'localhost',
            'port' => 25,
            'from' => "gitlab-manage@#{hostname}",
            'to' => "root@#{hostname}",
            'disable_tls' => false,
            'show_diff' => true,
            'use_primitive_command' => false,
            'options' => {}
          }
        }
      end
    end

    def initialize(datas) # rubocop:disable Metrics/AbcSize
      @datas = Util.deep_merge_hash(
        datas, Config.default_config
      )

      # general
      @data_dir = @datas['general']['data_dir']
      @cache_dir = @datas['general']['cache_dir']

      # mail
      @mail =
        if @datas['mail']['enable']
          {
            host: @datas['mail']['host'],
            port: @datas['mail']['port'],
            from: @datas['mail']['from'],
            to: @datas['mail']['to'],
            disable_tls: @datas['mail']['disable_tls'],
            show_diff: @datas['mail']['show_diff'],
            use_primitive_command: @datas['mail']['use_primitive_command'],
            options: @datas['mail']['options']
          }
        else
          {}
        end
    end

    def [](key)
      @datas[key]
    end

    # general
    attr_reader :data_dir
    attr_reader :cache_dir

    # mail
    def mail_index(key)
      @mail[key]
    end

    def use_mail?
      !@mail.nil?
    end

    def mail_host
      @mail[:host]
    end

    def mail_port
      @mail[:port]
    end

    def mail_from
      @mail[:from]
    end

    def mail_to
      @mail[:to]
    end

    def mail_disable_tls
      @mail[:disable_tls]
    end

    def mail_show_diff
      @mail[:show_diff]
    end

    def mail_use_primitive_command
      @mail[:use_primitive_command]
    end
  end
end
