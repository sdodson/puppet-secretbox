module Puppet::Parser::Functions
  newfunction(:secretbox, :type => :rvalue) do |args|
    # There must be a key passed as the first argument, which is used to index
    # the generated value
    raise Puppet::ParseError, "Missing persistance key" if args[0].empty?

    # Where the files are stored between runs. This directory should be
    # locked-down, permissions-wise.
    persistance_dir = File.join(Puppet[:vardir], 'randpersist', lookupvar('fqdn'))
    # The individual file that actually stores the contents
    persistance_file = File.join(persistance_dir, args[0])

    # Make the directory if it doesn't already exist.
    unless File.directory? persistance_dir
      require 'fileutils'
      FileUtils.mkdir_p persistance_dir
    end

    if File.exists? persistance_file
      # The file exists, assume it's contents are what we wanted.
      open(persistance_file).read.strip
    else
      # Otherwise, generate a string
      length = args[1] || 32
      # We use all ASCII values 32 through 126, excluding a few: ' " # /
      characters = (32..126).to_a - [35,34,39,47]

      password = SecureRandom.random_bytes(length).each_char.map do |char|
        characters[(char.ord % characters.length)].chr
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
