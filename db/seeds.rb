#encoding:utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
founder1 = User.create!(
                    :full_name              => "حامد رمضانیان",
                    :email                  => "h.ramezanian@jnaqsh.com",
                    :password               => "secret",
                    :password_confirmation  => "secret"
                    )
founder2 = User.create!(
                    :full_name              => "آرش موسوی",
                    :email                  => "a.mosavi@jnaqsh.com",
                    :password               => "secret",
                    :password_confirmation  => "secret"
                    )

approved = User.create!(
                    :full_name              => "کاربر تاییدشده",
                    :email                  => "approved@jnaqsh.com",
                    :password               => "secret",
                    :password_confirmation  => "secret"
                    )

new_user = User.create!(
                    :full_name              => "کاربر جدید",
                    :email                  => "new_user@jnaqsh.com",
                    :password               => "secret",
                    :password_confirmation  => "secret"
                    )

Role.delete_all
Role.create([{:name => "founder"}, {:name => "approved"}, {:name => "new_user"}])

founder1.roles << Role.find_by_name("founder")
founder2.roles << Role.find_by_name("founder")
approved.roles << Role.find_by_name("approved")
new_user.roles << Role.find_by_name("new_user")
