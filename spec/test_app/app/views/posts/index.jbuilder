json.jason do
  body do
    sections do
      items do
        @post.each{|p| label p.title }
      end
    end
  end
end
