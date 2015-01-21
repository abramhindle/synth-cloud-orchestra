require 'erb'
require_relative 'synthdef'
require 'fileutils'

class Templater
  include ERB::Util
  attr_accessor :localconnections, :connections, :hosts, :syncdir, :instrument, :module, :command, :syncdir, :synthdef

  def synths_of(host)
    puts "synths_of: #{host.alias}"
    blocks = @synthdef.blocks.select do |key,block|
      block.host.alias == host.alias
    end
    puts blocks.keys
    return blocks.values
  end

  def is_remote(synth)
    synth.is_a? RemoteBlock
  end

  def synth_of(name)
    m = name.match("^_remote:(.*)$")
    if (m)
      synthname = m[1]
      synth = self.synth_of(synthname)
      return RemoteBlock.new(synth)
    end
    return @synthdef.blocks[name]
  end

  def connection_synths(connection)
    source = synth_of(connection.source)
    sink = synth_of(connection.sink)
    if self.is_remote(source)
      warn "Source is remote!"
      source.host = sink.host
    end
    [source, sink]
  end

  def initialize(synthdef)
    @synthdef = synthdef
    @localconnections = synthdef.locals
    @connections = synthdef.remotes
    @hosts = synthdef.slaves
    @instrument = synthdef.name
    @syncdir = "cloudorchestra" # + Pathname.new(".").realpath.basename.to_s
    puts @syncdir
  end

  def get_binding
    binding()
  end

  def render_template( str )
    renderer = ERB.new( str )
    return renderer.result(self.get_binding)
  end

  def render_file( filename )
    self.render_template( File.new( filename).read )
  end

  def render_file_to_file( filename, fileout )
    self.save( self.render_file( filename ), fileout)
  end

  def save(data, file)
    dir = File.dirname(file)
    unless (File.exist? dir)
      FileUtils.mkdir_p(dir)
    end
    File.open(file, "w+") do |f|
      f.write(data)
    end
  end

  def render_everything()
    files = Dir.glob("../gen.erb/**/*").collect {|x| x }.select {|y| File.file? y }
    Dir.mkdir("./gen")
    # now gen the erbs
    files.each do |file|
      outfile = file.sub("../gen.erb/","gen/")
      warn(outfile)
      self.render_file_to_file(file,outfile)
    end
    # now gen the synths
    @synthdef.blocks.each do |key,block|
      infile = "../gen.erb/synth-.sh"
      outfile = "gen/synth-#{block.name}.sh"
      @module = block.module
      @command = block.command
      warn(outfile)
      self.render_file_to_file(infile,outfile)
    end
  end

end
