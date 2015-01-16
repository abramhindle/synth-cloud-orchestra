require 'erb'

class Templater
  include ERB::Util
  attr_accessor :localconnections, :connections, :hosts, :syncdir, :instrument, :module, :command, :syncdir, :synthdef

  def synths_of(host)
    raise "Not done"
  end

  def initialize(synthdef)
    @synthdef = synthdef
    @localconnections = synthdef.locals
    @connections = synthdef.remotes
    @hosts = synthdef.slaves
    @instrument = synthdef.name
    @syncdir = Pathname.new("..").realpath.dirname.basename
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
  end

end
