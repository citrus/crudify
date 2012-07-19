Crudify
=======

A dynamic resource controller for Rails 3 that keeps your controllers nice and skinny.

Crudify was shamelessly robbed from [refinerycms](https://github.com/resolve/refinerycms/blob/master/core/lib/refinery/crud.rb)'s internals and customized for use in other projects. Much credit and many thanks to the guys at [resolve digital](http://resolvedigital.com/) for all their hard work on the [refinery cms project](http://resolvedigital.com/development/refinery%C2%A0cms). Keep it up!


Installation
------------

It's best to install crudify by adding your Rails 3 project's Gemfile:

    # Gemfile
    source "http://rubygems.org"
    gem 'rails',   '>= 3.0.0'        
    gem 'crudify', '>= 0.0.7'

Now run:

    bundle install
    

Usage
-----

In its most basic form, crudify is designed to be use like this:

    class JelliesController < ApplicationController
      crudify :jelly
    end
    
    
Ok, so what does it do? The short answer; _everything_ that you'd want it to. In more detail, crudify turns your controller into a full-fledged CRUD controller with `index`, `new`, `create`, `show`, `edit`, `update`, and `destroy`. But wait, there's more! Inside each of these standard methods are several _hook methods_ designed to make customizing your controllers even easier that overwriting crudify's methods. Overwriting; say what? ... 

Say you want to customize an action that's being defined by crudify, simply overwrite it!

    class JelliesController < ApplicationController
      crudify :jelly
      
      def create     
        @jelly = Jelly.new(params[:jelly])
        # ... the rest of your custom action
      end
    end
    

Ok that seems easy enough, but what if my action is just a tiny bit different? That's where the _hook methods_ come in...

### Hook Methods

Laced into crudify's actions are a module full of methods designed to make customizing your controller quick and simple. Let's examine these methods in further detail starting with create.

Here's what lines #45-59 in `lib/crudify/class_methods.rb` will produce in our Jellies controller:

    def create
      # if the position field exists, set this object as last object, given the conditions of this class.
      if Jelly.column_names.include?("position")
        params[:jelly].merge!({
          :position => ((Jelly.maximum(:position, :conditions => "")||-1) + 1)
        })
      end
      @instance = @jelly = Jelly.new(params[:jelly])
      before_create
      if @instance.valid? && @instance.save
        successful_create
      else
        failed_create
      end
    end
    

Just before the calls to `valid?` and `save`, you'll see `before_create`; the first hook method in the action. Looking further into the source, `before_create` is nothing more than a blank action, waiting to be overwritten:

      def before_create
        # just a hook!
        puts "> Crud::before_create" if @crud_options[:log]
        before_action
      end
      

Notice that `before_create` calls a second hook; `before_action`. This is a generic hook that fires before every crud method's call to `save`, `update` or `destroy`. This means it might be helpful for you to call `super` when overwriting this method so that the chain of hooks keeps firing. Inside the `before_action` method we'll decide what to use as flash messages with `set_what`. Here's the code for `before_action`:

      def before_action
        # just a hook!
        puts "> Crud::before_action" if @crud_options[:log]
        set_what
        true
      end
      

*Ok Ok, so we're gettin' kind of deep here.* Let's get back to the basic concept; Skinny, sexy and easy on the eyes. (Are we still talking ruby here?) 

Here's an example of a `before_create` hook:

    class InquiriesController < ApplicationController
      crudify :inquiry
      
      def before_create
        @inquiry.ip_address = request.remote_addr
        super
      end
      
    end
      

And a `successful_create` hook:

    class InquiriesController < ApplicationController
      crudify :inquiry
      
      def successful_create
        InquiryMailer.message(@inquiry).deliver!
        super
      end
      
    end


### To find out more about crudify, read the source! Here's some helpful links:

* For available **options**: [Crudify::Base](https://github.com/citrus/crudify/blob/master/lib/crudify/base.rb)
* For available **hooks**: [Crudify::HookMethods](https://github.com/citrus/crudify/blob/master/lib/crudify/hook_methods.rb)
* To see **which hooks go where**: [Cruidfy::ClassMethods](https://github.com/citrus/crudify/blob/master/lib/crudify/class_methods.rb)

Also, check out the demo app in `test/dummy`...


Testing
-------

Shoulda and Capybara/Selenium tests can be run by cloning the repo and running `rake`:

    git clone git://github.com/citrus/crudify.git
    cd crudify
    bundle install
    rake    


To Do
-----

There's a few things to be done still...

* Tests for search
* More Documentation & Examples
* Nested set tests and demo (haven't even tried this yet :/)
* Generally more thorough tests
* Refactoring/Optimizing


License
-------

Although many things have been rewritten, crudify is released under [Resolve Digital's](http://www.resolvedigital.com) original license since portions code were extracted from their [refinerycms](http://github.com/resolve/refinerycms) project.

### MIT License
 
Copyright (c) 2005-2010 [Resolve Digital](http://www.resolvedigital.com)
 
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
 
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
