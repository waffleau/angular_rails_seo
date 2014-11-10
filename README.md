# Angular-Rails SEO

## Introduction
One of the greatest pains of working with client-side frameworks is developing an effective SEO strategy, as page crawlers generally don't load javascript. To resolve this you usually need to write some form of server hack to deliver different content when visited by a crawler.

This gem aims to make working with AngularJS within the Rails asset pipeline a little bit easier. It provides a unified method of sharing page metadata between the server and client application.


## History
1.0.0: Initial release
1.1.0: Dynamic path matching and parent assignment


## Getting started

### seo.json

The first step is to create an `seo.json` file at the root of your Rails application. You can do this manually or with the command `rake seo:create`.

This file has the following basic structure:

    {

      "default" : {
        "title" : "This is a test page",
        "description" : "Come to my site for all the test pages you could ever want!",
        "author" : "Kermit the Frog"
      },

      "/projects" : {
        "title" : "This is the projects page",
        "description" : "A list of all the projects we're working on"
      },

      "/projects/*" : {
        "model" : "Project",
        "parent" : "/projects"
      },

      "/users" : {
        "title" : "A list of all of the users",
        "author" : "Miss Piggy"
      },

      "/users/*" : {
        "exclude" : true
      }

    }

Each key corresponds to a route within your application. An explanation of the functionality offered:

1. `default`: The fallback values to use on pages without specific definitions.
2. `/projects`: Will apply to the /projects path, and no child paths.
3. `/projects/*`: The `*` is a wildcard, so this path represents any direct child path of /projects - e.g. /projects/my-first-project. The `model` attribute means that this path is dynamic, and in this case the gem should look at the Project model to resolve the SEO data. This is explained further below. The `parent` attribute tells this entry which data to inherit for missing fields. In this example, individual project pages will use the `/projects` meta description.
4. `/users`: Another example of a single matched page. The description will be the same as the "default" description.
5. `/users/*`: Will match any direct child of /users, but explictly not apply the "default" settings. Use this if you want to dynamically name this page at runtime.

That's it for basic route parsing!


### Ruby on Rails
There are a number of view helpers, but the easiest way to get up and running is to insert this into the `<head>` of your application layout file:

`<%= seo_tags %>`

This will create a `<title>` field, a `<meta name="description">` field and a `<meta name="author">` field. All three will be kept up to date automatically.

If you've use the `model` attribute in your seo.json file, the gem will attempt to look up details from the supplied model. A method `seo_match` will be invoked against the class, which should return a hash with SEO details. You will need to implement this method on any class for which you specify a `model` attributes. For example, if we specify an attribute of `"model" : "Project"`, this should be added to your Project model definition:

    def self.seo_match(args)
      project = Project.published.find(args[0])

      return { title: project.name }
    end

The `args` parameter is a list of URL wildcard components, which can be used to look up the requested model. For example, if we were to request `/projects/this-is-a-project`, `args[0]` would be the first wildcard match which is `this-is-a-project`.

The hash returned from this method will then be treated as a normal seo.json entry.


### AngularJS
Using sprockets, import `//= require "angular-rails-seo"`, and then load the module `angular-rails-seo`. All routing information will then be automatically applied.

If you want to set a custom title for a page, you can inject the `$seo` service into your controller, then use `$seo.setTitle("This is a custom title")`. There is a gotcha though: if you've defined an SEO title for the matching entry, it will be the one used. To avoid this, you need to use either the `model` or `exclude` attributes.
