require "open3"

class Zenweb::Page
  def render_ts(page, content)
    Open3.popen2("babel --filename=#{File.basename(page.path)}") do |stdin, stdout, _|
      stdin.print(body)
      stdin.close
      stdout.read
    end
  end
end
