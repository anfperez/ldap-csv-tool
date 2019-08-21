=begin
describe "LDAP CSV Tool" do
    it "exists" do
        ldap.
end
=end

describe "the CSV file loads correctly" do
    it "gets the attributes of the CSV" do
    expect(output).to eq "[[\"cn\", \"sn\", \"mail\", \"uid\"], [\"Angela\", \"Perez\", \"anfperez@gmail.com\", \"angela\"]]"
    #STDOUT.should_receive(:puts).with("[[\"cn\", \"sn\", \"mail\", \"uid\"], [\"Angela\", \"Perez\", \"anfperez@gmail.com\", \"angela\"]]")
    end
end

=begin
describe "if the LDAP server is connecting",
    include_context "running on Docker"
    host='127.0.0.1'
    describe "LDAP host",
        it_behaves_like "LDAP host running on Docker"
    end
end


expect(File).to receive(:open).with("example.csv", "r").and_return rows
=end
