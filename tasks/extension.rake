namespace :extension do  
    desc "Build the extension(s)"
    task :build do
        Hightimes::GEM_SPEC.extensions.each do |extension|
            path = Pathname.new(extension)
            parts = path.split
            conf = parts.last
            Dir.chdir(path.dirname) do |d| 
                ruby conf.to_s
                sh "rake default"
            end
        end
    end 
end

