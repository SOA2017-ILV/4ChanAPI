# frozen_string_literal: false
# not implemented yet -- need exception handleing for posts without Images

module Load4Chan
  # Provides access to contributor data
  class Images
    def initialize(post_data)
      @post = post_data
    end

    def ImageID
      @post['tim']
    end

    def Imagename
      @post['semantic_url']
    end

    def ImageURL
      @post['']
    end
  end
end
