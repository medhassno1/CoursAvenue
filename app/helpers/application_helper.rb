module ApplicationHelper

  def current_admin
    current_admin_user
  end

  # Overriding Kaminari's method
  # https://github.com/amatsuda/kaminari/blob/master/lib/kaminari/helpers/action_view_extension.rb
  def page_entries_info(collection, options = {})
      entry_name = if options[:entry_name]
        options[:entry_name]
      elsif collection.empty? || collection.is_a?(PaginatableArray)
        'entry'
      else
        if collection.respond_to? :model  # DataMapper
          collection.model.model_name.human.downcase
        else  # AR
          collection.model_name.human.downcase
        end
      end
      entry_name = entry_name.pluralize unless collection.total_count == 1

      if collection.total_pages < 2
        t('helpers.page_entries_info.one_page.display_entries', :entry_name => entry_name, :count => collection.total_count)
      else
        first = collection.offset + 1
        last = collection.last_page? ? collection.total_count : collection.offset + collection.limit_value
        t('helpers.page_entries_info.more_pages.display_entries', :entry_name => entry_name, :first => first, :last => last, :total => collection.total_count)
      end.html_safe
    end

end
