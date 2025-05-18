require 'rails_helper'

RSpec.describe DashboardsController, type: :controller do
  describe "GET #show" do
    let!(:show1) { create(:show) }
    let!(:show2) { create(:show) }

    let!(:performance1) { create(:performance, show: show1) }
    let!(:performance2) { create(:performance, show: show2) }

    let!(:buyer1) { create(:buyer, age: 30) }
    let!(:buyer2) { create(:buyer, age: 40) }

    let!(:booking1) { create(:booking, performance: performance1, buyer: buyer1, price: 10.0) }
    let!(:booking2) { create(:booking, performance: performance2, buyer: buyer2, price: 20.0) }
    let!(:booking3) { create(:booking, performance: performance1, buyer: buyer1, price: 15.0) }

    context "without show_id" do
      before { get :show, params: { show_id: nil } }

      it "assigns all shows" do
        expect(assigns(:shows)).to match_array([ show1, show2 ])
      end

      it "assigns all performances" do
        expect(assigns(:performances)).to match_array([ performance1, performance2 ])
      end

      it "calculates correct stats" do
        expect(assigns(:reservation_count)).to eq(3)
        expect(assigns(:unique_buyers)).to eq(2)
        expect(assigns(:average_age)).to eq((30 + 40).to_f / 2)
        expect(assigns(:average_price_per_perf)).to eq(((10 + 20 + 15).to_f / 2).round(2))
      end
    end

    context "with show_id 'all'" do
      before { get :show, params: { show_id: "all" } }

      it "assigns all shows" do
        expect(assigns(:shows)).to match_array([ show1, show2 ])
      end
    end

    context "with specific show_id" do
      before { get :show, params: { show_id: show1.id.to_s } }

      it "filters performances" do
        expect(assigns(:performances)).to eq([ performance1 ])
      end

      it "filters bookings" do
        expect(assigns(:bookings)).to match_array([ booking1, booking3 ])
      end

      it "filters buyers" do
        expect(assigns(:buyers)).to eq([ buyer1 ])
      end

      it "calculates filtered stats" do
        expect(assigns(:reservation_count)).to eq(2)
        expect(assigns(:unique_buyers)).to eq(1)
        expect(assigns(:average_age)).to eq(30)
        expect(assigns(:average_price_per_perf)).to eq(((10 + 15).to_f / 1).round(2))
      end
    end
  end
end
