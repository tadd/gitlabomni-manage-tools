# frozen_string_literal: true

require_relative '../util/gitlabomni'

module GitLabOmnibusManage
  module SubCommands
    module ShowTemplateCommand
      module_function

      def get_target_version(pkg, options)
        if options[:available]
          pkg.available_version
        else
          pkg.current_version
        end
      end
    end

    def command_show_template
      target_version = ShowTemplateCommand.get_target_version(@pkg, options)

      puts GitLabOmnibusManage::Util.get_gitlab_template(target_version)
    end
  end
end
