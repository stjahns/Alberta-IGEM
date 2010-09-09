# this is a role for locking the whole site so that we have a way for people to # log in as guests
default_role=Role.find_or_create_by_name('guest')
default_role.update_attributes(
                :description => "Guest user role, same permissions as default role",
                :permissions => Role.find_by_name('default').permissions
)


