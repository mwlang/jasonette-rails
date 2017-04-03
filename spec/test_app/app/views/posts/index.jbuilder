json.jason do
  body do
    sections do
      items do
        # label_temp 'wwwwww'
        # label_temp 'yyyyyy'
        @post.each{|p| label p.title }
      end
    end
  end
end
