require 'rubygems'
require 'net/ldap'
require 'csv'
require 'rspec'

csv_file = ARGV

def get_ldap_response(ldap)
    msg = "Response Code: #{ ldap.get_operation_result.code }, Message: #{ ldap.get_operation_result.message }"
  
    raise msg unless ldap.get_operation_result.code == 0
  end

#connects to the LDAP server
ldap = Net::LDAP.new  :host => '127.0.0.1',
  :port => 1300,
  :auth => {
    :method => :simple,
    :username => 'cn=admin,dc=example,dc=org',
    :password => 'admin'
}

puts ldap.get_operation_result


filter = Net::LDAP::Filter.eq( "cn", "Jane*")
treebase = "dc=example,dc=org"

=begin I used this code to perform a search through the LDAP database for the relevant data
ldap.search( :base => treebase, :filter => filter ) do |entry|
  puts "DN: #{entry.dn}"
  entry.each do |attribute, values|
    puts "   #{attribute}:"
    values.each do |value|
      puts "      --->#{value}"
    end
  end
end
=end

# this is where I tried to get the LDAP information into CSV format. I only got as far as the headers.
ldap.search( :base => treebase, :filter => filter ) do |entry|
  CSV.open("mysearch.csv", "w") do |csv|
        csv << entry.each do |entry|
  end
end
end

=begin
ldap.search( :base => treebase, :filter => filter ) do |entry|
  CSV.open("mysearch.csv", "w") do |csv|

     #entry.each do |attribute, values|
        csv << entry.each do |entry|
        #values.each do |value|
         # csv << [value]
     # end
      # csv << values.each do |value|
   #end
  end
end
end
=end

#this is where I attempted to input an entry into the LDAP server. This is the sample entry I wrote, with dn and attr
dn = "uid=christine,ou=people,dc=example,dc=org"
attr = {
  :cn => "Christine",
  :sn => "Mariani",
  :objectClass => "inetOrgPerson",
  :mail => "christine@example.com",
  :uid => "christine"
}

=begin first attempt at trying to add an entry -- opening a connection again, then using ldap.add
Net::LDAP.open(:host => '127.0.0.1') do |ldap|
  ldap.add(:dn => dn, :attributes => attr)
end
=end

=begin second attempt to add entry to LDAP, using ldap.add_attribute
ldap.add_attribute('ou=people,dc=example,dc=org',
                    'cn',
                    'christine')
#end

=begin third attempt to add entry to LDAP, using ldap.add without trying to open a connection
ldap.add(:dn => dn, :attr => attr)
=end

=begin fourth attempt to add entry to LDAP, tried writing a function
def add_entry(dn:, attributes:)
        Net::LDAP.open(config) do |ldap|
          ldap.add(dn: dn, attributes: attributes)
          result = ldap.get_operation_result
          log result unless result.code.zero?
          logger.warn result unless result.code.zero?
        end
      end
end
end
=end
=begin


data_array = [] 

ldap.search( :base => treebase, :filter => filter ) do |entry|
  CSV.open("mysearch.csv", "w") do |csv|

     #entry.each do |attribute, values|
        csv << entry.each do |entry|
        #values.each do |value|
         # csv << [value]
     # end
      # csv << values.each do |value|
   #end
  end
end
end

=begin
# this one kinda works but there has to be a better solution
ldap.search( :base => treebase, :filter => filter ) do |entry|
  CSV.open("mysearch.csv", "w") do |csv|
  puts "DN: #{entry.dn}"
  entry.each do |attribute, values|
    csv << [values, attribute]
    search_array.push(attribute)
    puts "   #{attribute}:"
    values.each do |value|
     #csv << [attribute, values]
     data_array.push(values)
     #search_array.push(value)
     #csv << [value]
      puts "      --->#{value}"
      #search_array.push(value)
    end
    end
  end 
end
=end
=begin
ldap.search( :base => treebase, :filter => filter ) do |entry|
  CSV.open("mysearch.csv", "w") do |csv|
    csv <<  entry.each do |attribute, values|
        csv << values.each do |value|
     # csv << key.each do |key|
   # end
end
end
    #entry.each do |attributes, values|
    #  csv << values
    #csv<< entry.each do |values|
  #end
end
end
=end
#this needs to become an LDAP entry
rows = CSV.open('example.csv', headers:true, return_headers:true).map(&:fields)
puts "here are rows"
p rows
p rows.class
=begin
csv_str = rows.inject([]) { |csv, row|  csv << CSV.generate_line(row) }.join("")
File.open("ss.csv", "w") {|f| f.write(rows.inject([]) { |csv, row|  csv << CSV.generate_line(row) }.join(""))}

puts "here is search array"
puts search_array

p ldap.get_operation_result

p ldap.get_operation_result.error_message

#adding = CSV.open('example.csv', 'r') << w%(header1 header2 header3 header4)
stuff = CSV.read('example.csv', headers: true)

stuff.each_with_index do |row, _i|
  cn = row[:cn]
  sn = row[:sn]
  mail = row[:mail]
  uid = row[:uid]
end

=begin
output = CSV.foreach('example.csv') do |row|
    puts row.inspect
end
=end
puts "here is output"





=begin
Net::LDAP.open (:host => '127.0.0.1') do |ldap|
  ldap.add( :dn => dn2, :attributes => attr2 )
end
=end

puts ldap.get_operation_result
