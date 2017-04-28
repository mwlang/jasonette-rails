template_vars = params[:template_vars] << "baz"
json.jason do
  set! "foo", "in template"
  if template_vars.present?
    template_vars.each do |var|
      set! "template_var_#{var}", var
    end
  end
end