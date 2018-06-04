module Jekyll
  class PagedFeedPageGenerator < Generator
    safe true

    def generate(site)
      # Generate feed for podcast episodes
      podcast_posts = site.posts.docs.map {|post| post if post.post_type == 'pod'}.compact
      pages_total = (podcast_posts.count.to_f / site.config['episodes_per_feed_page']).ceil
      post_type = 'pod'
      site.config["episode_feed_formats"].each do |page_format|
        name = "episodes." + page_format + ".rss"
        page = PagedFeedPage.new(site, site.source, ".", name, 1, pages_total, page_format, post_type)
        site.pages << page
        (1..pages_total).each do |page_number|
          name = "episodes" + page_number.to_s + "." + page_format + ".rss"
          page = PagedFeedPage.new(site, site.source, ".", name, page_number, pages_total, page_format, post_type)
          site.pages << page
        end
      end

      # Generate feed for blog posts
      blog_posts = site.posts.docs.map {|post| post if post.post_type == 'blog'}.compact
      pages_total = (blog_posts.count.to_f / site.config['blog_posts_per_feed_page']).ceil
      name = "blog_posts.rss"
      page_format = nil
      post_type = 'blog'
      page = PagedFeedPage.new(site, site.source, ".", name, 1, pages_total, page_format, post_type)
      site.pages << page
      (1..pages_total).each do |page_number|
        name = "blog_posts" + page_number.to_s + ".rss"
        page = PagedFeedPage.new(site, site.source, ".", name, page_number, pages_total, page_format, post_type)
        site.pages << page
      end
    end
  end
end
