# frozen_string_literal: false

#require_relative 'images.rb' #not implimented
#require_relative 'threads.rb'

module Load4Chan
  # Model for Repo
  class Posts
    def initialize(post_data, thread_source)
      @post = post_data
      @thread_source = thread_source
    end

    def post_number
      @post['no']
    end

    def subject
      @post['sub']
    end

    def comment
      @post['com']
    end

    def image
      # TBD
    end
  end
end
