set :output, "log/cron.log"

every 1.day, at: "2:00 am" do
  puts "Running tmp:cleanup_csv"
  rake "tmp:cleanup_csv"
end
