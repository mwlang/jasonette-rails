json.jason do
  head do
    data do
      foo "foo"
      app_foo app_foo
      post_foo post_foo
      block_foo (app_foo do
        "_with_block"
      end)
    end
  end
end
