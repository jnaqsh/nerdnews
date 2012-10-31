#encoding: utf-8

class Tag < ActiveRecord::Base
  attr_accessible :name, :thumbnail

  has_attached_file :thumbnail, :styles => { thumb: "64x64#" }

  has_many :taggings, dependent: :destroy
  has_many :stories, :through => :taggings

  validates :name, uniqueness: true, presence: true
  validates_attachment :thumbnail, :presence => true,
    :content_type => {:content_type => ['image/jpeg', 'image/jpg', 'image/png']},
    :size => { :in => 0..100.kilobytes }

  searchable do
    string :name
    time :created_at
  end

  private

    def self.tokens(query)
      tags = where("name like ?", "%#{query}%")
    end

    def self.ids_from_tokens(tokens)
      tokens.gsub!(/<<<(.+?)>>>/) { create!(name: $1).id }
      tokens.split(',')
    end
end
