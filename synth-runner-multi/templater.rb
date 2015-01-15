require 'erb'

class Templater
  include ERB::Util
  attr_accessor :localconnections, :connections, :hosts, :syncdir, :instrument, :instrumentdir, :module, :command

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
      f.write(render)
    end
  end

  def render_everything()
    Dir.glob("../gen.erb/**/*").collect {|x| x }.select {|y| File.file? y }
  end

end
