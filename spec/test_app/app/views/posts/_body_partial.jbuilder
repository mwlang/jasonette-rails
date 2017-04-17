json.jason do
  body do
    sections do
      type 'partial'
      items do
        @posts.each{|p| label p.title }
      end
    end
  end
end
