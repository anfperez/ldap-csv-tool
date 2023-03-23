# Ruby LDAP CLI Tool

## Built Using
* Visual Studio Code
* Ruby
* Ruby gems
.* CSV
.* ldap-net
* LDAP

## Features
* Users can upload a CSV file to add entries to the LDAP server
* Users can search the LDAP server and save their results to a CSV file

# Goals of this Assignment

## Goal 1
You can upload a CSV file to add entries to the LDAP server.
To do this, run `ruby my-ldap-cli-dir path/to/file.csv` in your terminal

You should see the following message
`"Added 3 entries to ou=people,dc=example,dc=org"`

## Goal 2

You can also perform a search for certain entries and save those results to a CSV.

## Step by Step Building process

I have never worked with LDAP before, so I tried to learn as much as I could from watching videos and reading tutorials online.

First, I set up a Docker server with the LDAP image.

I am able to view the LDAP image, as well as search and add entries to it on the command line.

--
### Connecting with Ruby

Next, I decided to try to manipulate the data in the LDAP server using Ruby. I included the following gems:

* ldap/net
* CSV

To connect to the LDAP server, I used the following syntax.

```ruby
ldap = Net::LDAP.new  :host => '127.0.0.1',
  :port => 1300,
  :auth => {
    :method => :simple,
    :username => 'cn=admin,dc=example,dc=org',
    :password => 'admin'
}
```

This allowed me to successfully link to the server.

### Adding Entries

Since I already knew how to add entries with the command line, I took a look to see if I could add entries with Ruby. I used the following code to test:

```ruby
dn = "uid=christine,ou=people,dc=example,dc=com"
attr = {
  :cn => "Christine",
  :sn => "Smith",
  :objectClass => "inetOrgPerson",
  :mail => "christine@example.com",
  :uid => "christine"
}

ldap.add(:dn => dn, :attributes => attr)
```
This is the exact syntax I saw in [this style guide](https://www.rubydoc.info/github/ruby-ldap/ruby-net-ldap/Net%2FLDAP:add). I also tried this:

```ruby
Net::LDAP.open(:host => '127.0.0.1') do |ldap|
  ldap.add(:dn => dn, :attributes => attr)
end
```

But this also did not work, since I already have a connection open to that LDAP server.

Whenever I ran this part of the program, I did not get any errors. However, my "Christine" entry was never added to the LDAP server. I am wondering if I added it to a different place, by mistake, since I do see that there are 7 entries in the LDAP server, but only 6 responses.

```
# numResponses: 7
# numEntries: 6
```

Since I could not add my entry to the LDAP server, I could not complete this part of the assignment. I did a lot of research trying to figure out if anything was wrong, but for now, I was not able to figure it out.

However, I did do some experiments with a CSV file to see if I could successfully contain the contents of a CSV file to prep it for entry on an LDAP server.

Using example.csv, I used the following code:

```ruby
rows = CSV.open('example.csv', headers:true, return_headers:true).map(&:fields)
```
To produce an array of arrays:
```
[["cn", "sn", "mail", "uid"], ["Angela", "Jones", "angela@example.com", "angela"]]
```
The next step here would be to add this as an entry to LDAP, once I figure out how to get the ldap.add function to work.

### Exporting LDAP Search to CSV

The other task to tackle was exporting the results of an LDAP search to a CSV file. I wanted to perform this function within the body of the Ruby program.

I ran a search for all entries with "cn=Jane*" as my parameter.

```ruby
filter = Net::LDAP::Filter.eq( "cn", "Jane*")
treebase = "dc=example,dc=org"

ldap.search( :base => treebase, :filter => filter ) do |entry|
  puts "DN: #{entry.dn}"
  entry.each do |attribute, values|
    puts "#{attribute}:"
    values.each do |value|
      puts "->#{value}"
    end
  end
end
```
This produces the following result.
```
DN: uid=jane,ou=people,dc=example,dc=org
   dn:
      --->uid=jane,ou=people,dc=example,dc=org
   objectclass:
      --->inetOrgPerson
   cn:
      --->Jane
   sn:
      --->Doe
   mail:
      --->jane@example.org
   uid:
      --->jane
```

The next step is exporting the data to CSV. This proved challenging. Originally I was planning to use key-value pairs or the .map function. But I realized that the entries have the class Net::LDAP::Entry, so key-value pairs or the .map function won't work. I have been trying to figure the best code to get the info from the entries. So far, the closest I have come is:
```ruby
ldap.search( :base => treebase, :filter => filter ) do |entry|
  CSV.open("mysearch.csv", "w") do |csv|
     #entry.each do |attribute, values|
        csv << entry.each do |entry|
          #csv << entry.each do |values|
            #values.each do |value|
            # csv << [value]
            #end
            #csv << values.each do |value|
        #end
        end
    end
end
```
The lines that are commented out are where I have tried to get the values from each attribute in the right format.

Originally, this worked with the headers.
```
dn,objectclass,cn,sn,mail,uid
```
But I also got this error:
```
#<OpenStruct extended_response=nil, code=53, error_message="no global superior knowledge", matched_dn="", message="Unwilling to perform">
```
After doing some research, I have determined that my path is incorrect. I was unable to figure out the correct path.

### RSPEC Tests

I installed the rspec gem and began to make a few tests to determine if the functions were working. Unfortunately, I was limited in the type of tests I could make because I could neither add entries nor export the search results to CSV.

I wrote three rspec tests:
* CSV file loads correctly
* LDAP server is connected
* CSV file is read and returns rows

## Commands

Commands to start the container
```
docker start -a my-ldap-cli-dir
```

Command to display info in the LDAP directory
```
docker exec my-ldap-cli-dir ldapsearch -x -H ldap://localhost -b dc=example,dc=org -D "cn=admin,dc=example,dc=org" -w admin
```

Command to search LDAP directory
```
ldapsearch -H ldap://localhost:1300 -D "cn=admin,dc=example,dc=org" -w admin -b 'dc=example,dc=org' 'objectClass=*' 
```
Command to input new data
```
ldapmodify -H ldap://localhost:1300 -D "cn=admin,dc=example,dc=org" -w admin <<+
dn: ou=people,dc=example,dc=org
changetype: add
objectClass: organizationalUnit
ou: people

dn: uid=jane,ou=people,dc=example,dc=org
changetype: add
objectClass: inetOrgPerson
cn: Jane
sn: Doe
mail: jane@example.org
uid: jane
+
```

Command to search for specific record
```
ldapsearch -H ldap://localhost:1300 -D "cn=admin,dc=example,dc=org" -w admin -b 'ou=people,dc=example,dc=org' 'uid=jane' 
```
