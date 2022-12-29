module ApplicationHelper
  def edit_and_destroy_buttons(item)
    return if current_user.nil?

    edit = link_to('Edit', url_for([:edit, item]), class: "btn btn-primary")
    del = button_to('Destroy', item,  method: :delete,
                                      form: { data: { turbo_confirm: "Are you sure ?" } },
                                      class: "btn btn-danger")
    raw("#{edit} #{del}")
  end

  def round(item)
    number_with_precision(item, precision: 1)
  end
end
