# frozen_string_literal: true

require 'erb'
require 'ostruct'
require 'socket'

module GitLabOmnibusManage
  module Util
    class IllegalUserOperationError < StandardError; end

    module_function

    def deep_merge_hash(base, ext, oldbase = true)
      base.merge(ext) do |_k, oldv, newv|
        if oldv.is_a?(Hash) && newv.is_a?(Hash)
          deep_merge_hash(oldv, newv, oldbase)
        elsif oldbase
          oldv
        else
          newv
        end
      end
    end

    class DeepOpenStruct < OpenStruct
      def self.openstruct_hash(hash)
        nhash = {}
        hash.each do |k, v|
          nhash[k] =
            if v.is_a?(Hash)
              DeepOpenStruct.new(v)
            else
              v
            end
        end

        nhash
      end

      def initialize(hash = nil)
        newarg =
          if hash.is_a?(Hash)
            DeepOpenStruct.openstruct_hash(hash)
          else
            hash
          end

        super(newarg)
      end
    end

    class ErbRenderer < DeepOpenStruct
      def render(template)
        ERB.new(template).result(binding)
      end
    end

    def render_erb_template(template, hash)
      ErbRenderer.new(hash).render(template)
    end

    def hostfullname
      Addrinfo.getaddrinfo(Socket.gethostname, nil)[0].getnameinfo[0]
    rescue SocketError
      'localhost'
    end

    def ask_yesno(message, default: true, retries: 3)
      ask_message = "#{message} #{default ? '[Yn]' : '[yN]'}: "

      print ask_message
      retries.times do
        s = STDIN.gets.downcase.strip

        return false if s.start_with?('n')
        return true if s.start_with?('y')
        return default if s == ''

        warn 'type `yes` or `no`'
        print ask_message
      end

      nil
    end
  end
end
