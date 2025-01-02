# Jekyll and Subresource Integrity

A small plugin to automate the generation of Subresource Integrity (SRI) hashes for linked files. It is one tool of the toolbox of modern browser features to increase the security of a website. As an example, it turns the following HTML:

```html
<script defer="" type="text/javascript" src="/scripts/main.js"></script>

<!-- other content -->

<link rel="stylesheet" href="/assets/css/style.css" />
```

Into this:

```html
<script
  defer=""
  type="text/javascript"
  src="/scripts/main.js"
  integrity="sha256-YK9s9fnHOUQ8vQsa/ftb4LSXAclQZxzu46g1nI6IQds="
  crossorigin="anonymous"
></script>

<!-- other content -->

<link
  rel="stylesheet"
  href="/assets/css/style.css"
  integrity="sha256-4733EDT8W6Ti+AW0WPy3mz0Xo5K9Opg39QS5gEldxz8="
  crossorigin="anonymous"
/>
```

## Installation

Add this line to your site's Gemfile:

```ruby
# If you have any plugins, put them here!
group :jekyll_plugins do

    # (...)

    # Used to generate the subresource integrity (SRI) hash of linked assets.
    # - https://github.com/Garanas/jekyll-subresource-integrity-hook

    gem 'jekyll-subresource-integrity-hook', git: "https://github.com/Garanas/jekyll-subresource-integrity-hook"
end
```

:warning: If you are using Jekyll < 3.5.0 use the `gems` key instead of `plugins`.

And then add the plugin to your site's configuration file:

```yaml
plugins:
  - (...)
  - jekyll-subresource-integrity-hook
```

## Usage

Once installed and configured you should be set. The plugin works via a [Jekyll Hook](https://jekyllrb.com/docs/plugins/hooks/). The hook triggers at the `:post_write` event. Of the list of events it is the last event that triggers. The plugin will look through all HTML files and add the `integrity` and `crossorigin` attributes to all [script](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/script) and [link](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/link) tags.

It is important that this plugin happens last, after any form of file manipulation. If files are manipulated after this plugin runs then the generated integrity hashes may not align with what the integrity hash that the browser computes. If this happens the browser will reject the resource. By rejecting it the file is not applied to your site. If this happens then the event is logged to the console as an error. The event is also reported by the browser if the [Report-To](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/report-to) header is defined.

## References

Various topics about modern browser security:

- [Subresource Integrity by Mozilla](https://www.keycdn.com/support/what-is-cache-busting)
- [Content Security Policy by Mozilla](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)

### Guides

- [Your first Jekyll plugin](https://perseus333.github.io/blog/jekyll-first-plugin)

### Similar projects

- [Jekyll Assets](https://github.com/envygeeks/jekyll-assets)

A plugin that can also produce the

- [SRI Hash Generator](https://www.srihash.org/)

A tool to manually generate the hash of a specific file. As an example, take this [blog post](https://thomasswilliams.github.io/development/2022/04/28/subresource-integrity.html) by Thomas Williams about it.
