class HomeController < ApplicationController
  require 'csv'

  def index
  end

  def settings
    @settings = Setting
  end
end
