# frozen_string_literal: false

require 'http'
require_relative 'post.rb'
# require_relative 'images.rb'
require_relative 'threads.rb'

module Load4Chan
  # Library for Github Web API
  class ChanAPI
    module Errors
      class NotFound < StandardError; end
      class Unauthorized < StandardError; end
    end

    HTTP_ERROR = {
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
    }.freeze

    def initialize(cache: {})
      @cache = cache
    end

    # def repo(username, repo_name)
    #   repo_req_url = gh_api_path([username, repo_name].join('/'))
    #   repo_data = call_gh_url(repo_req_url).parse
    #   Repo.new(repo_data, self)
    # end
    #
    # def contributors(contributors_url)
    #   contributors_data = call_gh_url(contributors_url).parse
    #   contributors_data.map { |account_data| Contributor.new(account_data) }
    # end
    def threads
      motivation_threads = search_fat_thread_id
      thread_urls = []
      motivation_threads.each { |tid| thread_urls << fit_chan_thread_path(tid) }
      thread_data = []
      thread_urls.each { |url| thread_data << call_thread_url(url) }
      thread_data.map do |data|
        Thread.new(data.parse['posts'], self)
      end
    end

    # private

    def search_fat_thread_id
      catalog_data = call_fit_catalog.parse
      found_threads = []
      catalog_data.map do |page|
        page['threads'].map do |op_post|
          title = op_post['com']
          thread_id = op_post['no'] if title.to_s.include? '/fat/ '
          found_threads << thread_id.to_s
        end
      end
      found_threads -= [nil, '']
    end

    def call_fit_catalog
      fit_catalog_url = 'https://a.4cdn.org/fit/catalog.json'
      response = call_thread_url(fit_catalog_url)
      response
    end

    def fit_chan_thread_path(thread_id)
      'https://a.4cdn.org/fit/thread/' + thread_id + '.json'
    end

    def call_thread_url(url)
      result = @cache.fetch(url) do
        HTTP.get(url)
      end
      successful?(result) ? result : raise_error(result)
    end

    def successful?(result)
      HTTP_ERROR.keys.include?(result.code) ? false : true
    end

    def raise_error(result)
      raise(HTTP_ERROR[result.code])
    end
  end
end
