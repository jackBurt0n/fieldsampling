class DaysController < ApplicationController
  require 'net/http'
   def index
     @dates = Day.
     select(" days.id, days.date, coalesce(sum(appointments.pulls),0) appts_pulls_sum, count(day_id) appts_count").
     joins("LEFT JOIN appointments on appointments.day_id = days.id").
     group("days.id, days.date") #uh... need to step through that -jlc
   end

   def show
    @date = Day.includes(:appointments).includes(:locations).find(params[:id])
    @locations = Location.all
    @time = 0
    origin = ERB::Util.url_encode("36.058241, -119.053045")
    destinations = @date.locations.where(id: @date.appointments.pluck(:location_id)).map{|x| [x.latitude, x.longitude].join(',')}.join('|')
    dest = ERB::Util.url_encode(destinations)
    url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=#{origin}&destinations=#{dest}&key=AIzaSyAtEhW3fIf9xkfpRZ8f_HEkV3pk2zxqsvI"
    uri = URI(url)
    dist_json = ActiveSupport::JSON.decode(Net::HTTP.get(uri))
    unless destinations.blank?
      dist_json["rows"].each do |json|
        json.each do |k,v|
          v.each do |kv|
            duration = kv["duration"]["value"] if kv["duration"] != nil
            if duration != nil
              duration = duration/(60*60)
              @time = duration + @time
            end
          end
        end
      end
    end
   end

   def new
     @date = Day.new
   end

   def create
     @date = Day.new(allowed_params)
#     if @date.save #not necessary since we won't be manually adding dates
#       redirect_to days_path
#     else
#       render 'new'
#     end
   end

   def edit
     @date = Day.find(params[:id])
   end

   def update #save changes
    unless params[:appointments].blank?
      params[:appointments].each do |id, attributes|
        if appointment = Appointment.find(id)
          appointment.update_attributes(attributes)
        end
      end
    end
     puts params #why? -jlc
     @date = Day.find(params[:id])
     @date.update_attributes(allowed_params)
     redirect_to day_path
   end

   def destroy
     @date = Day.find(params[:id])
     @date.destroy
     redirect_to days_path
   end

   def import
     Day.import(params[:file])
     redirect_to days_path, notice: "Dates Added Successfully"
   end

private
   def allowed_params
     params.require(:day).permit(:date, location_ids: [])
   end
end
