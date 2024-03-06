# frozen_string_literal: true

require 'rubygems'

Dir.glob(
  File.expand_path('../archpkg/*.rb', File.dirname(__FILE__))
).each do |entry|
  require_relative entry
end

module GitLabOmnibusManage
  module Util
    class NotSupportedPlatformError < StandardError; end

    module_function

    def gitlabpkg_linux
      if File.exist?('/etc/debian_version')
        GitLabOmnibusManage::ArchPkg.debian
      elsif File.exist?('/etc/redhat_release')
        GitLabOmnibusManage::ArchPkg.redhat
      else
        raise NotSupportedPlatformError, 'not supported linux platform'
      end
    end

    def gitlabpkg
      case Gem::Platform.local.os
      when 'linux'
        gitlabpkg_linux
      else
        raise NotSupportedPlatformError, 'not supported platform'
      end
    end
  end
end
