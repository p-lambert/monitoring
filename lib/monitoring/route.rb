Monitoring::Route = Proc.new do |env|
  [200, {"Content-Type" => "application/json"}, [Monitoring.report.read]]
end
