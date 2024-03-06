# frozen_string_literal: true

module GitLabOmnibusManage
  module SubCommands
    def command_backup
      `gitlab-rake#{options[:quiet] ? ' --quiet' : ''} gitlab:backup:create`
    end
  end
end
