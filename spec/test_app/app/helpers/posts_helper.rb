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

  def space_builder height, has_block
    if has_block && eval(has_block)
      jason_builder(:items).space height, &Proc.new { partial! "posts/foo" }
    else
      jason_builder(:items).space height
    end
  end

  def space_builder_component height, has_block
    if has_block && eval(has_block)
      component :space, height, &Proc.new { partial! "posts/foo" }
    end
  end

  def layout_builder
    layout do
      components do
        space "10"
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
