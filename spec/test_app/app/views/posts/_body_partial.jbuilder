json.jason do
  body do
    sections do
      items do
        @posts.each{|p| label p.title }
      end
    end
  end
end
