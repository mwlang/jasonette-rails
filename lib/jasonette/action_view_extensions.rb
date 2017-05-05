# module Jasonette
#   module TemplateRendererExtensions
#     def render(context, options)
#       @details      = extract_details(options)
#       path, locals  = options[:layout], options[:locals] || {}
#       layout        = path && find_layout(path, locals.keys, [formats.first])
#       JasonSingleton.fetch(context).instance_variable_set("@_has_layout", !layout.try(:virtual_path).nil?)
#       super
#     end
#   end
#   ::ActionView::TemplateRenderer.send(:prepend, TemplateRendererExtensions)
# end