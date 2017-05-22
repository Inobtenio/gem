# desc "Install Gema, cap install STAGES=staging,production"
task :install do
  Install.execute
end

task :verify do
  Gema.verify
end

task :net do
  
end