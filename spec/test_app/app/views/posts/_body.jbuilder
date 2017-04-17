body do
  sections do
    type 'inline'
    items do
      @posts.each{|p| label p.title }
    end
  end
end
