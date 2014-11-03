# Angular-Rails SEO

## Introduction
One of the greatest pains of working with client-side frameworks is developing an effective SEO strategy, as page crawlers generally don't load javascript. To resolve this you usually need to write some form of server hack to deliver different content when visited by a crawler.

This gem aims to make working with AngularJS within the Rails asset pipeline a little bit easier. It provides a unified method of sharing page metadata between the server and client application.

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
        "title" : "This is a single project"
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
3. `/projects/*`: The `*` is a wildcard, so this path represents any direct child path of /projects - e.g. /projects/my-first-project.
4. `/users`: Another example of a single matched page. The description will be the same as the "default" description.
5. `/users/*`: Will match any direct child of /users, but explictly not apply the "default" settings. Use this if you want to dynamically name this page at runtime.

That's it for basic route parsing!


### Ruby on Rails
There are a number of view helpers, but the easiest way to get up and running is to insert this into the `<head>` of your application layout file:

`<%= seo_tags %>`

This will create a `<title>` field, a `<meta name="description">` field and a `<meta name="author">` field. All three will be kept up to date automatically.


### AngularJS
Using sprockets, import `//= require "angular-rails-seo"`, and then load the module `angular-rails-seo`. All routing information will then be automatically applied.
