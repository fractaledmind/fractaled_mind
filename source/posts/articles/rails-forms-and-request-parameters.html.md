---
title: Rails Forms and Request Parameters
tags:
  - code>ruby
  - code>rails
date: 2018-07-29
---

Sometimes in our Rails applications we need to build forms that represent state stored in URL query parameters that is independent of any persisted object in our backend datastore, like in the case of a search form. In this post I offer a simple, flexible, generic helper for doing just that. 

{{read more}}

>**NOTE:** I first detailed this helper in a larger post on [basic RESTful filtering in Rails](http://fractaledmind.com/articles/basic-restful-filtering-with-rails/).

- - -

In a stock Rails app, we build forms using the `form_for` helper. This helper method expects an object, not a hash, so we cannot simply pass some `params` hash into the helper. Moreover, if you dig into the source code for the `form_for` method and the `FormBuilder` object it creates, you will see that it inspects the object it is passed for a `#model_name` method when constructing input names. It then expects the return value of the `#model_name` method to respond to the `#param_key` method (these methods are part of the [`ActiveModel::Naming`](http://api.rubyonrails.org/classes/ActiveModel/Naming.html) module). So, in order for our custom built object to work with `form_for` the way that we desire, we simply need to ensure that `object.model_name.param_key` returns the parameter namespace we desire.

So, we need a helper that:

1. takes a param name
2. returns an object
3. that object returns the param name for the `model_name.param_key` getter chain
4. that object returns any values stored in the params under the appropriate (possibly nested) keys

In order to access the appropriate bit of the URL query parameters, our helper first needs to accept the name of the param we are interested in:

~~~ruby
module FormForHelper
  def form_for_object_from_param(param)
  end
end
~~~

We then need to get the URL query parameters for this param key from the current request parameters (luckily for us, Rails provides the `params` getter to return an `ActionController::Parameters` object):

~~~ruby
module FormForHelper
  def form_for_object_from_param(param)
    form_for_params = params.fetch(param, {})
  end
end
~~~

In order to convert the hash returned from the `params.fetch` call, we can use the `JSON.parse(hash.to_json, object_class: OpenStruct)` approach:

~~~ruby
module FormForHelper
  def form_for_object_from_param(param)
    form_for_params = params.fetch(param, {})

    JSON.parse(form_for_params.to_json,
               object_class: OpenStruct)
  end
end
~~~

Finally, in order to ensure that the `model_name.param_key` getter chain returns the param name, we simply merge the params hash with a hash that `OpenStruct` will convert into that getter chain:

~~~ruby
module FormForHelper
  def form_for_object_from_param(param)
    form_for_params = params.fetch(param, {})
    form_for_requirements = { model_name: { param_key: param } }

    JSON.parse(form_for_params.merge(form_for_requirements).to_json,
               object_class: OpenStruct)
  end
end
~~~

And there it is! This is a simple, flexible, generic helper to create an object that can be passed to `form_for` which is backed by URL query parameters.
