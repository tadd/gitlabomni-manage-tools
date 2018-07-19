# frozen_string_literal: true

require_relative 'testpkg'

RSpec.describe GitLabOmnibusManage do
  describe 'running' do
    it 'is running without errors' do
      GitLabOmnibusManage::Application.new(pkg: TestPkg).run([])

      # check can run with TestPkg
      GitLabOmnibusManage::Application.new(pkg: TestPkg).run(['check'])

      # show-template can run with TestPkg
      GitLabOmnibusManage::Application.new(pkg: TestPkg).run(['show-template'])
    end
  end
end
