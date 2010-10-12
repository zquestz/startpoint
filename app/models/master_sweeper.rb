class MasterSweeper < ActionController::Caching::Sweeper
  # This sweeper is going to keep an eye on the User model
  observe User, Page, PageImage, Image

  # If our sweeper detects that a record was created call this
  def after_create(record)
    if Rails.configuration.cache_classes == true
      expire_cache_for(record, 'create')
    end
  end

  # If our sweeper detects that a record was updated call this
  def after_update(record)
    if Rails.configuration.cache_classes == true
      expire_cache_for(record, 'update')
    end
  end

  # If our sweeper detects that a record was deleted call this
  def after_destroy(record)
    if Rails.configuration.cache_classes == true
      expire_cache_for(record, 'destroy')
    end
  end

  private

  # Expire the actual caches, this is scoped by class.
  # Images are cached with pages, so will expire page caches.
  def expire_cache_for(record, callback)
    # Expire user caches
    if record.class == User
      real_keys = record.changes.keys.sort - ["last_request_at", "perishable_token", "updated_at"]
      if ( (real_keys != []) or (callback == 'destroy') )
        # Expire the caches in the User model for counts if records are created/deleted
        if (callback != 'update' || real_keys.include?("is_admin"))
          Rails.cache.delete('regular_user_count')
          Rails.cache.delete('admin_user_count')
        end
        # Expire the index now that a user has changed
        total_pages = (User.total_users_count.to_f / User.per_page).ceil
        (1..total_pages).each do |i|
          Rails.cache.delete("accounts_index-#{i}")
        end
        # Expire their profile page.
        Rails.cache.delete("accounts_show-#{record.id}")
      end
    elsif record.class == PageImage
      Rails.cache.delete("show_page-#{record.page.name}")
    elsif record.class == PagePdf
      Rails.cache.delete("show_page-#{record.page.name}")
    elsif record.class == Image
      for page in record.pages
        Rails.cache.delete("show_page-#{page.name}")
      end
    elsif record.class == Pdf
      for page in record.pages
        Rails.cache.delete("show_page-#{page.name}")
      end
    elsif record.class == Page
      Rails.cache.delete("show_page-#{record.name}")
    end
  end
end
