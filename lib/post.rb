# frozen_string_literal: false

# require_relative 'images.rb' #not implimented

module Load4Chan
  # Model for Repo
  class Posts
    def initialize(post_data, thread_source)
      @post = repo_data
      @data_source = data_source
    end

    def size
      @repo['size']
    end

    def owner
      @owner ||= Contributor.new(@repo['owner'])
    end

    def git_url
      @repo['git_url']
    end

    def contributors
      @contributors ||= @data_source.contributors(@repo['contributors_url'])
    end
  end
end
