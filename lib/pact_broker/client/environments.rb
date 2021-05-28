Dir.glob(File.join(__FILE__.gsub(".rb", "/**/*.rb"))).sort.each do | path |
  require path
end
