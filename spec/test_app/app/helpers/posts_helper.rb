module PostsHelper
  def post_foo
    "post_foo"
  end

  def add_jason_builder_posts
    jason_builder(:head) do
      action "test" do
        success
      end 
    end
  end 

  def public_posts val
    { "public_helper_posts" => val }
  end

  private

  def private_posts val
    { "private_helper_posts" => val }
  end
end
