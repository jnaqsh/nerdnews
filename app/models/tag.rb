#encoding: utf-8

class Tag < ActiveRecord::Base
  attr_accessible :name

  has_many :taggings, dependent: :destroy
  has_many :stories, :through => :taggings

  private

    def self.tokens(query)
      tags = where("name like ?", "%#{query}%")
    end

    def self.ids_from_tokens(tokens)
      tokens.gsub!(/<<<(.+?)>>>/) { create!(name: $1).id }
      tokens.split(',')
    end
end
