# frozen_string_literal: false

require_relative 'posts.rb'

module Load4Chan
  # Model for Repo
  class Thread
    def initialize(thread_data, data_source)
      @data = thread_data
      @data_source = data_source
    end

    def size
      @data[0]['replies'] # data[0] is the original post
    end

    def op
      @op ||= post.new(@data[0])
    end

    def posts
      @data.map { |thread_post| Post.new(thread_post, self) }
    end
  end
end
