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

file = "Contents/Resources/Documents/index.html"
doc = Nokogiri::HTML(File.read(file))
guides = doc.css('h5 > a').to_a.delete_if { |x| x.content.capitalize != x.content }
guides.each do |guide|
  puts "INSERT INTO searchIndex VALUES (NULL, '#{guide.content}', 'Guide', '#{guide.attributes["href"].value}');"
end
