# encoding: utf-8
require 'spec_helper'

describe Rating do
  it { should respond_to :name }
  it { should respond_to :weight }
end