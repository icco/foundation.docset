require 'nokogiri'

def get_header doc
  headers = doc.css('h2').collect { |x| x.content }
  if !headers.empty?
    headers.first
  else # Shit isn't consistent.
    doc.css('h1').collect { |x| x.content }[2]
  end
end

puts "CREATE TABLE IF NOT EXISTS searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);"

ARGV.each do |file|
  doc = Nokogiri::HTML(File.read(file))
  header = get_header doc

  puts "INSERT INTO searchIndex VALUES (NULL, '#{header}', 'framework', '#{file}');"
end
