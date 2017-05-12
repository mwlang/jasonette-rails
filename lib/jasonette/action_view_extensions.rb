module Jasonette
  module TemplateRendererExtensions
    def render(context, options)
      @details      = extract_details(options)
      path, locals  = options[:layout], options[:locals] || {}
      layout        = path && find_layout(path, locals.keys, [formats.first])
      if !layout.try(:virtual_path).nil?
        JasonSingleton.fetch(context).layout = layout
        JasonSingleton.fetch(context).locals = locals
      end
      super
    end
  end
  ::ActionView::TemplateRenderer.send(:prepend, TemplateRendererExtensions)
end