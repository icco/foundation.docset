require 'nokogiri'

def get_header doc
  headers = doc.css('h2').collect { |x| x.content }
  if !headers.empty?
    headers.first
  else # Shit isn't consistent.
    doc.css('h1').collect { |x| x.content }[2]
  end
end

puts "DROP TABLE searchIndex;"
puts "CREATE TABLE IF NOT EXISTS searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);"
puts 'CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);'

Dir.glob("Contents/Resources/Documents/components/*html").each do |file|
  doc = Nokogiri::HTML(File.read(file))
  file_name = File.join("components", File.basename(file))
  header = get_header doc
  puts "INSERT INTO searchIndex VALUES (NULL, '#{header}', 'Guide', '#{file_name}');"
end
