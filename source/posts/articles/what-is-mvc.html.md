---
title: What is MVC?
tags:
  - code>rails
  - code>mvc
date: 2018-02-21
---

As a part of a recent job application process, I was asked a few general questions pertaining to software development. I thought I would share the questions and my answers here on my blog.

### The Question

Please describe in as much detail as you think is appropriate what the MVC design pattern is, what the responsibilities of the Model, View, and Controller are, both in general and in Rails specifically, and what the benefits of this separation are. Also touch on how the Concern and Service patterns fit into this.

{{read more}}

- - -

#### On Models

Models are abstract representations of problem spaces. The model layer in an MVC application is the structured set of all model objects. A model object, then, represents some combination of structured data and logic. The entirety of the problem space is the model layer. That large space is broken down into smaller sections; each section is a model object. Each model object has getters that provide access to its data and state as well as setters that provide access for changing its data and state.

In Rails, many model objects represent database tables (wired up by means of ActiveRecord). Rails thus tends to have many model objects that are model resources. A model resource is a database-backed object-oriented class that is RESTfully wired up (via the `config/routes.rb` file) into the application. Note, however, that not all model objects, even in Rails, need be model resources. However, since the `app/models` directory is where ActiveRecord model resource classes are put, many Rails developers can come to infer that the "model" in MVC is _simply_ a database-backed object-oriented class. This is, however, an overly restrictive understanding.

#### On Views

Views are concrete representations of data and actions. A view can be rendered in any number of formats (e.g. html, json, csv, xml, pdf, etc.), but is bound to one model. Views present a model to the external world of the application (e.g. a user or another application). The HTML responses of a web application and the JSON responses of a wep API are both views.

In Rails, views lives in the `app/views` directory and are bound to model resources. Rails allows a developer to build views for any number of formats. Every resource is expected to have views for up to 4 GET actions:

- index
- new
- show
- edit

#### On Controllers

Controllers are the switchboard of the application; they bind interactions from the user to actions in the model and ensure that the correct views are rendered for the user. Controllers are responsible for making sense of the incoming request and returning the appropriate outgoing response. The controller layer can thus be thought of as a middleman between the model layer and the view layer.

Along with the view layer, the controller layer is focused on the external world. The controller layer handles what the external world _does_ to the model layer, while the view layer handles what the external world _sees_ from the model layer. The model layer is not directly exposed to the external world. This is one key component to the separation of concerns that drives the benefits of the MVC pattern.

In a standard RESTful Rails application, the controller will get or set data from a model resource and use a view to return HTML output. It makes the model data available to the view so it can display that data to the user, and it saves or updates user data to the model. The controller classes live in `app/controllers` and each class will inherit from `ActionController::Base`.

#### Benefits

The key benefit of the MVC architecture pattern is the separation of concerns between the internal bits (the model) and the external bits (the controller and view). The model layer provides an interface that the controller and view layers can use to then provide an interface to the user. This separation of concerns provides two key benefits:

1. managed complexity
2. predictable structure

You can think of complexity in terms of a graph. Each part of your application is a node in the graph and each relationship between the parts is an edge, and the direction of the relationship is the direction of edge. One form of complexity could simply be the total number of edges, and the MVC pattern does some to alleviate this form of complexity. Think, for example, of the fact that a view is bound to one model. Another form of complexity could be the number of cycles (a circular path) each node is a part of. With a well-structured MVC application, each node (e.g. a specific model resource) should only be a part of one cycle (the path that connects the model to its controller that is connected to its views). By managing the complexity of an application, the MVC pattern helps developers to build/maintain the application.

The MVC pattern also helps developers build/maintain the application by providing a predictable structure. If you are working on a task that relates to how the user sees some bit of information, you need to be working in the view layer. If you are working on a feature that allows the user to take some action that changes the state, you should be working in the controller layer. If you need to map out new terrain in the problem space, structuring some combination of data and logic, work in the model layer. Rails furthers this aid by having strong conventions for where certain files live and what classes they should inherit from. Predictability helps keep the complexity of the system as a whole low.

If a Rails application follows the MVC pattern well, a developer ought to be able to get the application data into whatever state he or she needs only through the Rails console, completely eschewing the controller or view layers. This is a strong sign that the concerns have been well-separated and that the model layer properly models the problem space of the application.

#### Concerns

This issue of complexity, however, has also driven the development of additional patterns that build on top of MVC. Let's say that an application has some behaviors that are shared among numerous objects. Where should this logic live? If we duplicate the code across the various model objects, our code isn't DRY, which increases the odds that the functionality will drift and differ over time from object to object.

The logic is clearly not related to the view layer, and it isn't bound to any input or actions from the external world, so it doesn't make sense to put it in the controller layer. Rather, what we need is a finer-grained sense of responsibilities for objects in the model layer. Enter the Concern Pattern.

A concern is an independent bit of functionality. It does not depend on any particular model resource, but can be mixed into any model resource to extend that resources behaviors. In Rails, the `ActiveSupport::Concern` module provides the basic infrastructure for creating new concerns that can be mixed into model resource classes (in essentially the same way as plain Ruby modules, just with a bit of extra "magic").

I will add that while concerns are very often used in the model layer, they are not restricted there. You can also have behaviors that are shared across numerous controllers, and a controller layer concern would make sense there.

#### Services

The Service Pattern provides a similar benefit as the Concern Pattern: it extends MVC to provide a finer-grained way to manage complexity and establish predictable structure.

Service objects typically slot into the space where models and controllers meet. Instead of spreading the task across the model and controller layers, the service layer provides a single place to collect the entire interation logic. Common examples include dealing with a user's forgotten password or processing a payment. In a "standard" MVC approach, the code for the lifecycle of this action would be split across the model and the controller, and may even require working with multiple models. With a single service object to represent the entirety of the action, you can better organize and separate the discrete sections of the your application and its logic.

#### Conclusion

In the end, the goal is always the same: to write robust applications that are understandable and maintainable. The MVC pattern is a time-worn and well-tested architecture that helps human developers structure large code bases. Rails specifically, with its emphasis on convention over configuration, uses the MVC pattern to great effect, allowing its structure to form the backbone of Rails' conventions. And while large and complex applications will likely need additional layers to manage and structure their complexity, these layers (like the concern and service layers) build on top of the MVC pattern and do not overturn it.
