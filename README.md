# Such

* [VERSION 1.0.210114](https://github.com/carlosjhr64/such/releases)
* [github](https://www.github.com/carlosjhr64/such)
* [rubygems](https://rubygems.org/gems/such)

## DESCRIPTION:

Wraps widgets with an alternate constructor
which factors out the configuration and assembly procedures into metadata.
Can be used to wrap any class with the alternate constructor,
although currently only Gtk3 widgets is supported.

## INSTALL:

```shell
$ sudo gem install such
```

## SYNOPSIS:

```ruby
require 'gtk3'
require 'such'
include Such; Things.gtk_widget

Thing.configure window: {
                  set_title: 'Synopsis Example',
                  set_window_position: :center },
                BUTTON: [label: 'Button!'],
                button: {set_size_request: [100,50], into:[:add]}

window = Window.new(:window, 'destroy'){Gtk.main_quit}
  Button.new(window, :button!){puts 'Button pressed!'}
window.show_all

Gtk.main
```

## MORE:

Arrays are passed to constructer's super,
Hashes are method=>arguments pairs, and Strings are signals.
Other objects are assumed to be containers:

```ruby
Such::Button.new(window, [label: 'Hello!'], {set_size_request:[100,50]}, 'clicked' ){puts 'OK'}

# Is equivalent to

button = Gtk::Button.new(label:'Hello!')
window.add button
button.set_size_request 100, 50
button.signal_connect('clicked'){puts 'OK'}
```

To set the packing method to say, :pack_start, set the :into method as follows:

```ruby
   {into: [:pack_start, expand:false, fill:false, padding:0]}
   # The effect in the contructor will be as if the following was run:
   #    container.pack_start(self, expand:false, fill:false, padding:0)
```

One can configure Symbol keys to represent metadata about a widget:

```ruby
   Thing.configure(
     KEY: [ arg1, arg2, arg3 ], # an array for super(arg1, arg2, arg3)
     key: {                     # a hash for like self.method(args)
       meth1:args1,
       meth2:[args2a, args2b],
       meth3:[a,b,c,d]
     },
     key!: [[arg1, arg2], {meth1:args1, meth2:args2}, 'signal1', 'signal2'] # the splatter bang!
   )
```

The examples in this repository are reworks of the examples given in
ZetCode.com[http://zetcode.com/gui/rubygtk/] (back in 2015).

## Features:

* :key! content *splat
* Undefined :key! expanded to :KEY, :key
* Missing signal assumed to be 'clicked'
* Heuristics on when one wants to iterate a method over the arguments given
* Packing method defaults (ultimately) to :add
* Way to change default packing behaviour

## But wait!  One more thing:

See link:examples/such_parts_demo in the examples directory
and link:test/tc_part for hints on how to use the much powerful
Such::Part module link:lib/such/part.rb

## LICENSE:

(The MIT License)

Copyright (c) 2021 CarlosJHR64

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
