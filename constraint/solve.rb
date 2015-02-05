require 'erb'

class HostSynthSolver
  include ERB::Util

  attr_accessor :hostnames, :cores, :synthnames, 
    :connections, :alpha, :solution,
    :solved
  def initialize(hostnames, cores, synthnames, connections,alpha=100)
    @hostnames = hostnames
    @cores = cores
    @synthnames = synthnames
    @connections = connections
    @alpha = alpha
    @solved = false
  end

  def safename(prefix, name)
    sname = name.gsub(/[^a-zA-Z0-9_]/,'_')
    "#{prefix}_#{sname}"
  end
  
  def hostlist
    return @hostnames.map {|x| self.safename("Host",x) }
  end
  def synthlist
    return @synthnames.map {|x| self.safesynth(x) }
  end
  def hostcoremap
    self.hostlist.zip(@cores).flatten.join(" ")
  end

  def safesynth(synth)
    self.safename("Synth",synth)    
  end

  def synths_connected_to(synth)
    conns = connections.select do |x| 
      x[0] == synth 
    end
    v = conns.map {|x| self.safesynth(x[1]) }.join(" ")
    return v
  end

  def make_src
    self.render_file_to_file("synth.mod.erb","synth.mod")
  end

  def parse_synth_out(str)
    tokens = str.split(/[ \t]+/)
    tuples = []
    while(tokens.length > 0)
      token = tokens.shift
      if token.match(/^a\[/)
        more = tokens.shift
        i = more.to_i
        (host,synth) = token.match(/^a\[([^,]+),([^\]]+)\]$/)[1..2]
        if (i!=0)
          tuples.push([host,synth])
        end
      end
    end
    safehostmap = Hash[self.hostlist.zip(@hostnames)]
    safesynthmap = Hash[self.synthlist.zip(@synthnames)]
    t = tuples.map do |t|
      [safehostmap[t[0]],safesynthmap[t[1]]]
    end
    return t.sort
  end

  def read_output
    self.parse_synth_out(open("synth.out").read())
  end

  def run_glp
    system("glpsol --math synth.mod  --wcpxlp synth.cplex --output synth.out --write synth.w")
    
  end
  def solve
    warn "Make Src"
    self.make_src
    warn "Run GLPK"
    self.run_glp
    warn "Output!"
    tuples = self.read_output
    @solved = true
    @solution = tuples
  end
  

  # return the pairs of hosts to synths
  def get_host_synth_pairs
    if (not @solved) 
      raise "Not solved!"
    end
    # parse the output file for a[Host,Synth]
    return @solution
  end

  # cloned code...
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


end

if $0 == __FILE__
  hosts = ["Host Big","Host One","Host Two","Host Three","Host Four"]
  cores = [2, 2, 2, 2, 2]
  synthnames = ["adc","fm 1","lp 1","lp 2","dac"]
  connections = [["adc","lp 1"],["lp 1", "lp 2"],
                 ["lp 1","dac"],["fm 1","lp 1"],
                 ["fm 1","dac"],["lp 2","dac"]
                ]

  inputstr = <<END   
   No. Column name       Activity     Lower bound   Upper bound
------ ------------    ------------- ------------- -------------
     1 a[Host_Host_Big,Synth_adc]
                                   0             0               
     2 a[Host_Host_One,Synth_adc]
                                   0             0               
     3 a[Host_Host_Two,Synth_adc]
                                   0             0               
     4 a[Host_Host_Three,Synth_adc]
                                   1             0               
     5 a[Host_Host_Four,Synth_adc]
                                   0             0               
     6 a[Host_Host_Big,Synth_fm_1]
                                   0             0               
     7 a[Host_Host_One,Synth_fm_1]
                                   0             0               
     8 a[Host_Host_Two,Synth_fm_1]
                                   1             0               
     9 a[Host_Host_Three,Synth_fm_1]
                                   0             0               
    10 a[Host_Host_Four,Synth_fm_1]
                                   0             0               
    11 a[Host_Host_Big,Synth_lp_1]
                                   1             0               
    12 a[Host_Host_One,Synth_lp_1]
                                   0             0               
    13 a[Host_Host_Two,Synth_lp_1]
                                   0             0               
    14 a[Host_Host_Three,Synth_lp_1]
                                   0             0               
    15 a[Host_Host_Four,Synth_lp_1]
                                   0             0               
    16 a[Host_Host_Big,Synth_lp_2]
                                   1             0               
    17 a[Host_Host_One,Synth_lp_2]
                                   0             0               
    18 a[Host_Host_Two,Synth_lp_2]
                                   0             0               
    19 a[Host_Host_Three,Synth_lp_2]
                                   0             0               
    20 a[Host_Host_Four,Synth_lp_2]
                                   0             0               
    21 a[Host_Host_Big,Synth_dac]
                                   0             0               
    22 a[Host_Host_One,Synth_dac]
                                   0             0               
    23 a[Host_Host_Two,Synth_dac]
                                   0             0               
    24 a[Host_Host_Three,Synth_dac]
                                   0             0               
    25 a[Host_Host_Four,Synth_dac]
                                   1             0               
    26 overflow[Host_Host_Big]
                                   0             0               
    27 overflow[Host_Host_One]
                                   0             0               
    28 overflow[Host_Host_Two]
                                   0             0               
    29 overflow[Host_Host_Three]
                                   0             0               
    30 overflow[Host_Host_Four]
                                   0             0           
END

  solver = HostSynthSolver.new(hosts,cores,synthnames,connections)
  host_pairs = solver.parse_synth_out(inputstr)
  raise "Hosts not same size" if not host_pairs.length == synthnames.length 
  puts host_pairs
  solver.solve()
  pairs = solver.get_host_synth_pairs
  puts pairs
end
