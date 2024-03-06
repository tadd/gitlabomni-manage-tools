lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitlabomni_manage_tools/version'

Gem::Specification.new do |spec|
  spec.name = 'gitlabomni-manage-tools'

  spec.version = GitLabOmnibusManage::VERSION
  spec.date = Time.now.strftime('%Y-%m-%d')
  spec.license = 'MIT'
  spec.required_ruby_version = '>=3.1'

  spec.authors = 'mizunashi-mana'

  spec.summary = 'This tools provide some features for GitLab Omnibus management'
  spec.description = <<~DESCRIPTION
    This tools provide below features for GitLab Omnibus:
      * Notify new updates of GitLab Omnibus for manager.
      * Update GitLab Omnibus more easily.
  DESCRIPTION
  spec.homepage = 'https://github.com/mizunashi-mana/gitlabomni-manage-tools'

  spec.platform = Gem::Platform::RUBY

  spec.add_dependency('lockfile')
  spec.add_dependency('mail')
  spec.add_dependency('thor')

  spec.add_development_dependency('bundler')
  spec.add_development_dependency('pry')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rubocop')

  spec.files = `git ls-files -z`.split("\x0")
  spec.test_files = `git ls-files -z -- {test,spec,features}/*`.split("\x0")
  spec.bindir = 'exe'
  spec.executables = `git ls-files -z -- exe/*`
    .split("\x0").map { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
