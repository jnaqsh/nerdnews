# coding:utf-8
class Role < ActiveRecord::Base
  has_and_belongs_to_many :users

  validates_uniqueness_of :name
  validates_presence_of :name

  ROLES_PERSIAN={new_user: 'کاربر جدید', approved: 'تاییدشده', founder: 'موسس'}

  def to_persian
    ROLES_PERSIAN[name.to_sym]
  end
end
