# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # Render's flash notices and errors
  def render_flash_messages
    output = ''
    flash.each do |key,value|
      output = ([:notice, :error].include?(key) ? content_tag(:div, value, :class => key.to_s) : nil)
    end
    return output
  end
  
  # Display cached images for pages.
  # You can send a size (symbol or string) with an id or name.
  # Examples --
  # display_image(@page, {:id => 1, :size => :large})
  # display_image(@page, {:name => 'name'})
  # display_image(@page, {:name => 'name', :size => 'icon'})
  def display_image(page, options = {})
    if options[:id].present?
      image = page.images.select {|image| image.id == options[:id]}.first
    elsif options[:name].present?
      image = page.images.select {|image| image.name == options[:name]}.first
    end
    image ? image_tag(image.file.url((options[:size] ? options[:size].to_sym : :original ))) : ''
  end
  
  # Quick way to link a url. Pass options to add classes/etc.
  def display_website(url, options = {})
    return link_to(url, url, options)
  end
  
  # Quick way to link an email address. Works just like display_website
  def display_email(email, options = {})
    return link_to(email, 'mailto:' + email, options)
  end
  
  # This calculates which sort to use and generates a link for you.
  def sort_calc(name, column, options = {})
    condition = options[:unless] if options.has_key?(:unless)
    sort_direction = params[:d] == 'ASC' ? 'DESC' : 'ASC'
    link_to_unless condition, name, request.parameters.merge( {:c => column, :d => sort_direction} )
  end
  
  # Generate small toolbar of sort links
  # This is fully localized, hence the conditions.
  def sort_bar(items, joinval = ' | ')
    Array(items) if items.class != Array
    sort_links = []
    if ['admin/users', 'users'].include?(controller.controller_name)
      items.each do |c|
        sort_links.push(sort_calc(t("activerecord.attributes.user.#{c}"), c))
      end
    elsif ['pages'].include?(controller.controller_name)
      items.each do |c|
        sort_links.push(sort_calc(t("activerecord.attributes.page.#{c}"), c))
      end
    elsif ['galleries'].include?(controller.controller_name)
      items.each do |c|
        sort_links.push(sort_calc(t("activerecord.attributes.gallery.#{c}"), c))
      end
    elsif ['images'].include?(controller.controller_name)
      items.each do |c|
        sort_links.push(sort_calc(t("activerecord.attributes.image.#{c}"), c))
      end
    else
      items.each do |c|
        sort_links.push(sort_calc(c.to_s.humanize, c))
      end
    end
    sort_links.join(joinval)
  end
  
  # Smuggled from http://rubyglasses.blogspot.com/2009/07/adding-prompt-to-selecttag.html
  # Thanks Taryn for your code
  # override select_tag to allow the ":include_blank => true" and ":prompt => 'whatever'" options
  include ActionView::Helpers::FormTagHelper
  alias_method :orig_select_tag, :select_tag
  def select_tag(name, select_options, options = {}, html_options = {})
    # remove the options that select_tag doesn't currently recognise
    include_blank = options.has_key?(:include_blank) && options.delete(:include_blank)
    prompt = options.has_key?(:prompt) && options.delete(:prompt)
    
    # if we didn't pass either - continue on as before
    return orig_select_tag(name, select_options, options.merge(html_options)) unless include_blank || prompt

    # otherwise, add them in ourselves
    prompt_option  = '<option value="">' # to make sure it shows up as nil
    prompt_option += (prompt ? prompt.to_s : '') + '</option>'
    new_select_options = prompt_option + select_options
    orig_select_tag(name, new_select_options, options.merge(html_options))
  end

end