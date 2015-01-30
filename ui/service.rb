require 'webrick'

root = File.expand_path './plumb'
server = WEBrick::HTTPServer.new :Port => 8080, :DocumentRoot => root
trap 'INT' do server.shutdown end

class WriteConfig < WEBrick::HTTPServlet::AbstractServlet
  def do_POST(request, response)
    begin
      status, content_type, body = save_config(request)
    rescue => e
      warn e.message
      warn e.backtrace
      status, content_type, body = [503, "text/plain", "There's been an error #{e.message}"]
    end    
    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  def save_config(request)
    json = request.query['json'] || {}
    name = request.query['name'] || ('A'..'Z').to_a.sample(20).join("")
    raise "Bad name: Use only a-zA-Z0-9_ " if not name.match("^[a-zA-Z0-9_]+$")
    subdir = File.expand_path("..")
    fmdir = File.expand_path("../base-example")
    dir = File.expand_path "../#{name}/"
    raise "File exists! -- Choose a different name for your synth!" if (File.exists?(dir))
    raise "Bad Path, you are specifying something that doesn't exist" if (dir.index(subdir) != 0)
    system("cp","-r",fmdir,dir)
    synthdef = "#{dir}/synthdef.json"
    f =  open(synthdef, "w")
    f.write(json)
    f.close()
    system("bash finish.sh #{dir} &")
    return [200,'text/html', "Deploying! An xterm should popup if you're lucky!"]
  end
end

server.mount '/config', WriteConfig

server.start
