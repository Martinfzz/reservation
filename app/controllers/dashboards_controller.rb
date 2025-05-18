class DashboardsController < ApplicationController
  def show
    @shows = Show.all

    @performances = if params[:show_id].present? && params[:show_id] != "all"
                      Performance.where(show_id: params[:show_id])
    else
                      Performance.all
    end

    performance_ids = @performances.pluck(:id)
    @bookings = Booking.includes(:buyer).where(performance_id: performance_ids)

    @buyers = @bookings.map(&:buyer).uniq

    @reservation_count = @bookings.size
    @unique_buyers = @buyers.size
    @average_age = @buyers.map(&:age).compact.sum.fdiv(@buyers.size).round rescue 0
    @average_price_per_perf = if @performances.any?
      (@bookings.sum(&:price).to_f / @performances.size).round(2)
    else
      0.0
    end
  end
end
