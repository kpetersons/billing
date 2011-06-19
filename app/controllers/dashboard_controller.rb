class DashboardController < ApplicationController

  layout "dashboard"
  def show
    @recent_activity_matters = Matter.where("updated_at between ? and ?", Date.today-5, Date.today+1)
    @upcoming_deadlines_matters = Matter.joins(:matter_tasks).where('proposed_deadline between ? and ?', Date.today-1, Date.today + 5).all
  end

end
