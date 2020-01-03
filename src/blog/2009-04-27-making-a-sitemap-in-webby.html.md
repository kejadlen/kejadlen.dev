---
title: Making a sitemap in Webby
---

The code for making a sitemap in Webby:

```erb
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
<%
  @pages.find(:all,
              :in_directory => '',
              :extension => 'html',
              :recursive => true,
              :draft => nil).each do |page|
-%>
<url>
  <loc><%= Webby.site.base %><%= page.url %></loc>
  <lastmod><%= page.mtime.strftime('%Y-%m-%d') %></lastmod>
  <priority><%= page.blog_post ? 1 : 0.8 %></priority>
</url>
<% end -%>
</urlset>
```
