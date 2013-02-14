Assety - nodejs assets collector
====================

supported - coffee, sass, html for underscore
____________________

###Express middleware
```coffee

app.use(require("assety")({
  url_path    : "/assets"
  assets_path : __dirname + "/assets"
  public      : __dirname + '/public'
}))

```