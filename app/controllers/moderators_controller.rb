class ModeratorsController < ApplicationController
  before_filter :requires_moderator!

  def index
  end
end
