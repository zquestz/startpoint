module Admin::ImagesHelper
  # Allow user to see different styles on image show page.
  def style_select(image, params)
    style = params[:preview]
    pulldown = []
    # Loop through the keys to create what we need for the select
    for paperclip_style in image.file.styles.keys
      pulldown.push([paperclip_style.to_s.humanize, paperclip_style.to_s])
    end
    pulldown.push(["Original", "original"])
    url = url_for({:controller => 'admin/images', :action => 'show', :id => image, :preview => '__style__'})
    content_tag :form, :id => 'style_preview', :name => "style_preview_form", :action => "#" do
      select_tag :style_preview_select,
        options_for_select(pulldown.sort, style || 'edit'),
        :onchange => "window.location.href='#{url}'.replace('__style__', style_preview_form.style_preview_select.options[selectedIndex].value)"
    end
  end
end
