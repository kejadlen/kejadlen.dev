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
        .exclude("**/_config.yml")
        .select {|f| File.file?(f) }
        .map {|p| Page.new(self, p) }
    end

    def deps
      [out, *pages.map(&:out)]
    end
  end

  class Page
    def initialize(site, path)
      @site, @path = site, path

      ss = StringScanner.new(File.read(path))
      ss.scan(/^---$(?<frontmatter>(?~---))^---$/)
      @frontmatter = ss[:frontmatter] ? YAML.load(ss[:frontmatter]) : {}
      @content = ss.rest.strip

      segments = @path.split(?.)
      exts = []
      while @site.renderers.keys.include?(segments.last)
        exts << segments.pop
      end
      @segments, @exts = segments, exts
    end

    def out
      @segments.join(?.).sub(/^#{@site.src}/, @site.out)
    end

    def deps
      [@path, *layout.deps]
    end

    def render
      renderers = @exts.map {|ext| @site.renderers.fetch(ext) }
      content = renderers.inject(@content) {|c,r| r.(c) }

      layout.render(content)
    end

    private

    def config
      config = Pathname.new(@path).descend
        .map {|p| "#{p}/_config.yml" }
        .select {|p| File.file?(p) }
        .map {|p| YAML.load_file(p) }
        .inject({}, &:merge)
      config.merge(@frontmatter)
    end

    def layout
      @site.layouts.fetch(config.fetch("layout") { "default" }) { Layout::Noop }
    end
  end

  class Layout
    attr_reader *%i[ name path ]

    def initialize(path)
      @path = path
      @template = ERB.new(File.read(@path))
    end

    def name
      File.basename(path, ".*")
    end

    def render(content)
      @template.result_with_hash(content: content)
    end

    def deps
      [path]
    end

    module Noop
      def self.deps
        []
      end

      def self.render(content)
        content
      end
    end
  end
end
