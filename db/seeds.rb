# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
admin = User.create!(
                    :full_name              => "adminadmin", 
                    :email                  => "admin@admin.com", 
                    :password               => "admin", 
                    :password_confirmation  => "admin"
                    )
Role.delete_all
role = Role.create([{:name => "admin"}, {:name => "manager"}])

admin.roles << Role.find_by_name("admin")