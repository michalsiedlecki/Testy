require 'calabash-cucumber/ibase'

class EmergencyContactsPage < Calabash::IBase

  def trait
    "label text:'EMERGENCY CONTACTS'"
  end

  def leeo_will_call_label
    "label {text CONTAINS 'If Leeo detects a smoke or carbon monoxide alarm, we will alert you first with a push notification and phone call. If you don'}"
  end

  def cancel_button
    "button marked:'Back'"
  end

  def add_contact_button
    "UIView marked:'Button.add-contact'"
  end

  def edit_contact_label(name)
    "label marked:'#{name}'"
  end

  def close_emergency_contacts()
    await(timeout: 5)
    wait_for_element_exists(cancel_button)
    touch(cancel_button)
    page(ResidenceSettingsPage).await(timeout: 5)
  end

  def open_edit_contact(name)
    await(timeout: 5)
    touch(edit_contact_label(name))
    page(EditContactsPage).await(timeout: 5)
  end

  def open_add_contacts
    await(timeout: 5)
    touch(add_contact_button)
    page(AddContactsPage).await(timeout: 5)
  end

  def close_emergency_contacts
    await(timeout: 5)
    touch(cancel_button)
    page(ResidenceSettingsPage).await(timeout: 5)
  end
end
