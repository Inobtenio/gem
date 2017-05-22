# desc "Install Gema, cap install STAGES=staging,production"
task :install do
  Gema::Install.execute
end

task :verify do
  Gema.verify
end

task :net do
  
end