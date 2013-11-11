# Define the secretbox method; see README for more information and usage.
module Puppet::Parser::Functions
  newfunction(:secretbox, :type => :rvalue, :doc => <<-eodoc) do |args|
Requires an index be passed as the first parameter. This index, along with the
node's FQDN will be used to uniquely identify a secret. If the secret doesn't
exist prior to the call, it will be generated. In this instance, secretbox can
accept a second argument, which specifies the length of the randomly generated
value. If the second value is left unspecified, it defaults to 32 characters
long.

The generated value can contain any printable ASCII value (character codes 32
through 126), excluding single quote ('), double quotes ("), forward slash (/)
and hash (#).

Upon generation, the value is saved to a file named the passed index. The file
is stored in a directory named after the FQDN. This directory is then stored
within the 'secretbox' directory, underneath Puppet's 'vardir'. In practice,
a given index has it's value stored in `/var/lib/puppet/secretbox/FQDN/index`.
  eodoc
    # There must be a key passed as the first argument, which is used to index
    # the generated value
    fail Puppet::ParseError, 'Missing persistance index' if args[0].nil?

    # Where the files are stored between runs. This directory should be
    # locked-down, permissions-wise.
    persistance_dir = File.join(Puppet[:vardir], 'secretbox', lookupvar('fqdn'))
    # The individual file that actually stores the contents
    persistance_file = File.join(persistance_dir, args[0])

    # Make the directory if it doesn't already exist.
    unless File.directory? persistance_dir
      require 'fileutils'
      FileUtils.mkdir_p persistance_dir
    end

    if File.exists? persistance_file
      # The file exists, assume it's contents are what we wanted.
      open(persistance_file).read.chomp
    else
      # Otherwise, generate a string
      length = args[1] || 32
      # We use all ASCII values 32 through 126, excluding a few: ' " # /
      characters = (32..126).to_a - [35, 34, 39, 47]

      require 'securerandom'
      password = SecureRandom.random_bytes(length).each_char.map do |char|
        begin
          character_code = char.ord
        rescue NoMethodError # For Ruby 1.8 compatibility, which stock puppet on RHEL runs on :(
          character_code = char[0]
        end
        characters[(character_code % characters.length)].chr
      end.join

      # Save the generated string to a file so that it's the same in subsequent
      # calls (assuming the same index)
      save_file = open(persistance_file, 'w')
      save_file.puts(password)
      save_file.close

      # And return the value so that the puppet variable/parameter is, of
      # course, set.
      password
    end
  end
end
