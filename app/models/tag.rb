#encoding: utf-8

class Tag < ActiveRecord::Base
  attr_accessible :name, :thumbnail

  has_attached_file :thumbnail

  has_many :taggings, dependent: :destroy
  has_many :stories, :through => :taggings

  validates :name, uniqueness: true, presence: true, on: :create
  validates_attachment :thumbnail, :presence => true,
    :content_type => { :content_type => "image/jpg image/png" },
    :size => { :in => 0..100.kilobytes }

  private

    def self.tokens(query)
      tags = where("name like ?", "%#{query}%")
    end

    def self.ids_from_tokens(tokens)
      tokens.gsub!(/<<<(.+?)>>>/) { create!(name: $1).id }
      tokens.split(',')
    end
end
