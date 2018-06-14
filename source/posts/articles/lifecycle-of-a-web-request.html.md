---
title: The Lifecycle of a Web Request
tags:
  - code>http
  - code>rails
date: 2018-02-21
---

As a part of a recent job application process, I was asked a few general questions pertaining to software development. I thought I would share the questions and my answers here on my blog.

### The Question

A user browses to some URL in their browser. Please describe in as much detail as you think is appropriate the lifecycle of this request and what happens in the browser, over the network, on servers, and in the Rails application before the request completes.

{{read more}}

- - -

### The Lifecycle of a Web Request

When a user navigates to a URL in his or her browser, the very first thing that happens is the browser determining what the IP address of that URL is. Presuming the browser does not already have the IP address cached, it would use a DNS server to resolve the URL into an IP address.

With an IP address in-hand, the browser can now initiate the HTTP request to the host server. The browser will open a TCP connection to the IP address and send the HTTP request (in this case a GET request) to the host server.

On the host server for GitLab, the server software, whatever it is (Apache and Nginx are two that I know of), handles the now open TCP connection and passes the HTTP request to the application process. This is a stage that I know less about. I have worked with Apache, but not extensively. Most of my knowledge of Apache starts and ends at the application's `.htaccess` file.

Now that the HTTP request has been passed to the application process, Rails gets to work. Rails will first attempt to match the URL of the HTTP request to a route defined in the `config/routes.rb` file. When matched, Rails knows the controller and action that will process this request. Before calling the appropriate controller action, Rails ensures that the `request` object and the `params` object are properly hydrated from the raw HTTP request data.

When calling the controller action, Rails checks if any `before_filter`s have been defined the action (for example, authenticating the user) and runs any of those first. It will then call the actual controller action, the execution of which will end with some kind of view rendering (whether implicitly or explicitly).

With the view rendered, Rails passes this back as the HTTP response. Rails ensures that the HTTP response is properly formatted and filled with the proper data (like headers and cookies).

Finally the browser receives the response. In this case, the response will include HTML, CSS, and (likely) Javascript which the browser will render on the screen.

