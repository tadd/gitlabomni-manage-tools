# frozen_string_literal: true

require 'lockfile'
require 'mail'

require_relative '../util/base'
require_relative '../util/gitlabomni'
require_relative './update_index.rb'

module GitLabOmnibusManage
  module SubCommands
    module NotifyCronjobCommand
      class UpdateLockManager
        def self.create(config)
          UpdateLockManager.new(
            File.join(config.cache_dir, 'update_locked_version')
          )
        end

        def initialize(path)
          @path = path
        end

        def locked_version
          return nil unless File.exist?(@path)
          File.open(@path, 'r', &:read)
        end

        def update_lock(version)
          File.open(@path, 'w') do |io|
            io.print version
          end
        end
      end

      module_function

      def update_notify(options, pkg, config)
        if config.use_mail?
          mail = create_mail(options, pkg, config)

          delivery_options = {}
          delivery_options[:address] = config.mail_host
          delivery_options[:port] = config.mail_port
          if config.mail_disable_tls
            delivery_options[:tls] = false
            delivery_options[:enable_starttls] = false
            delivery_options[:enable_starttls_auto] = false
          end

          delivery_options = Util.deep_merge_hash(
            config.mail_index(:options),
            delivery_options
          )

          mail.delivery_method(
            :smtp,
            delivery_options
          )
          mail.deliver
        end

        # TODO: other works
        print ''
      end

      # mail
      MAIL_TEMPLATE_SUBJECT = <<~SUBJECT
        New version <%= pkg_version.available %> is available for GitLab
      SUBJECT
        .strip

      MAIL_TEMPLATE_BODY = <<~BODY
        Dear, GitLab Maintainers

        An update is available on https://gitlab.com/gitlab-org/

        Current Version : <%= pkg_version.current %>
        New Version     : <%= pkg_version.available %>

        The parameter changes: <%= template_diff.url %><%
          if template_diff.show_content
        %><%
          if template_diff.content != ''
        %>
        ```diff
        <%= template_diff.content %>
        ```<%
          else
        %>
        no template differences.<%
          end
        %><%
          end
        %>

        Please, update your GitLab:
        ```bash
        <%= command.update %>
        ```

        See also, https://about.gitlab.com/update/

        ---
        This mail was sent by the update manager automatically.
        😉 Happy works on GitLab!
      BODY

      def create_mail(options, pkg, config)
        mail_env = create_mail_environ(pkg, config)

        Mail.new do |m|
          m.charset = 'UTF-8'

          m.from config.mail_from
          m.to   options[:mailto] || config.mail_to

          m.subject NotifyCronjobCommand.mail_subject(mail_env)

          m.body NotifyCronjobCommand.mail_body(mail_env)
        end
      end

      def create_mail_environ(pkg, config)
        template_diff = {
          url: Util.diff_gitlab_url(
            pkg.current_version, pkg.available_version
          ),
          show_content: config.mail_show_diff
        }
        if template_diff[:show_content]
          template_diff[:content] =
            Util.diff_gitlab_template(pkg.available_version)
        end

        {
          pkg_version: {
            current: pkg.current_version,
            available: pkg.available_version
          },
          template_diff: template_diff,
          command: {
            update:
              if config.mail_use_primitive_command
                pkg.update_command
              else
                'gitlab-manage upgrade'
              end
          }
        }
      end

      def mail_subject(obj)
        Util.render_erb_template(
          MAIL_TEMPLATE_SUBJECT,
          obj
        )
      end

      def mail_body(obj)
        Util.render_erb_template(
          MAIL_TEMPLATE_BODY,
          obj
        )
      end
    end

    def command_notify_cronjob
      UpdateIndexCommand.update_index(@pkg, options)

      Lockfile(File.join(@config.cache_dir, 'notify-cronjob.lock')) do
        manager = NotifyCronjobCommand::UpdateLockManager.create(@config)
        return if !options[:force] && manager.locked_version == @pkg.available_version

        NotifyCronjobCommand.update_notify(options, @pkg, @config)

        manager.update_lock(@pkg.available_version)
      end
    end
  end
end
