require "erb"
require "strscan"
require "yaml"

require "rake/file_list"

module Webbie
  class Site
    attr_reader *%i[ src out layouts renderers pages ]

    def initialize(src: "src", out: "out", layouts: "_layouts", renderers: {})
      @src, @out = src, out

      @layouts = FileList["#{src}/#{layouts}/*.erb"]
        .map {|l| Layout.new(l) }
        .to_h {|l| [l.name, l] }

      @renderers = renderers.transform_keys(&:to_s)

      @pages = FileList["#{src}/**/*", "#{src}/**/.*"]
        .exclude(@layouts.values.map(&:path))
        .reject {|f| File.directory?(f) }
        .map {|p| Page.new(self, p) }
    end
  end

  class Page
    def initialize(site, path)
      @site, @path = site, path

      ss = StringScanner.new(File.read(path))
      ss.scan(/---$(?<config>(?~---))^---$/)
      @config = ss[:config] ? YAML.load(ss[:config]) : {}
      @content = ss.rest.strip

      segments = @path.split(?.)
      exts = []
      while @site.renderers.keys.include?(segments.last)
        exts << segments.pop
      end
      @segments, @exts = segments, exts

      @layouts = Array(@config["layout"]).map {|l| @site.layouts.fetch(l) }
    end

    def out
      @segments.join(?.).sub(/^#{@site.src}/, @site.out)
    end

    def deps
      [@path, *@layouts.map(&:path)]
    end

    def render
      renderers = @exts.map {|ext| @site.renderers.fetch(ext) }
      content = renderers.inject(@content) {|c,r| r.(c) }

      @layouts.inject(content) {|c,l| l.render(c) }
    end
  end

  class Layout
    attr_reader *%i[ name path ]

    def initialize(path)
      @path = path
    end

    def name
      File.basename(path, ".*")
    end

    def render(content)
      ERB.new(File.read(path)).result_with_hash(content: content)
    end
  end
end
