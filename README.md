# Jasonette Rails
A extension of the Jbuilder framework to facilitate building [Jasonette](https://github.com/Jasonette/JASONETTE-iOS)
flavored JSON in Rails.

## ALPHA code!

Warning:  Work in progress. Proceed with caution. Testers and contributions are welctemperatureroject is **alpha** code and still in highly experimental stage and subjected to
drastic changes to the DSL.  It is also quite full of bugs despite the unit tests you may find herein!

Note: Almost nothing about this gem is documented, however, you can find ample examples in the project's
spec/lib/jasonette/... folders.  Generally speaking, the DSL follows the $jason structure closely and supporting
classes are organized in sub-folders of the project's lib/jasonette/... accordingly.

### TODO

* render partial feature for option :as and :collection
* better error detection and handling
* refining implementation in the various classes
* document
* add Linting?

## Usage

If I haven't done enough to scare you away, then check out the code and play around and provide feedback!  
Some of the techniques I used are stretching the limits of my understanding of Rails rendering engine and
Ruby scoping, esp. with meta-programming, so watch out (and help out)!

This gem allows to to write the JSON structure expected by a Jasonette application in a much more powerful
way than with Jbuilder alone.

There's a demo app published here:  https://github.com/mwlang/jasonette-rails-demo/tree/gemified

The master branch has the traditional Jbuilder approach throughout.  The gemified branch is built using the
extensions of this gem.

For example:

Here's how the "hello.json" demo JSON would be rendered with this gem:

```ruby
head.title "{ ˃̵̑ᴥ˂̵̑}"
head.action("$foreground") { reload! }
head.action("$pull") { reload! }
body do
  sections do
    items do
      image image_url("rails-logo.png") do
        style do
          align "center"
          padding "30"
        end
      end
  
      layout :vertical do
        style do
          padding "30"
          spacing "20"
          align "center"
        end
        components do
          label "It's ALIVE!" do
            style do
              align "center"
              font "Courier-Bold"
              size "18"
            end
          end
    
          label do
            text "This is a demo app. You can make your own app by changing the url inside settings.plist"
            style do
              align "center"
              font "Courier"
              padding "10"
              size "14"
            end
          end
    
          label "{ ˃̵̑ᴥ˂̵̑}" do
            style do
              align "center"
              font "HelveticaNeue-Bold"
              size "50"
            end
          end
        end
      end
  
      label "Check out Live DEMO" do
        style do
          align "right"
          padding "10"
          color "#000000"
          font "HelveticaNeue"
          size "12"
        end
    
        href do
          url "file://demo.json"
          fresh "true"
        end
      end
    
      label "Watch the tutorial video" do
        style do
          align "right"
          padding "10"
          color "#000000"
          font "HelveticaNeue"
          size "12"
        end
        href do
          url "https://www.youtube.com/watch?v=hfevBAAfCMQ"
          view "web"
        end
      end
    
      label "View documentation" do
        style do
          align "right"
          padding "10"
          color "#000000"
          font "HelveticaNeue"
          size "12"
        end
        href do
          url "https://jasonette.github.io/documentation"
          view "web"
        end
      end
    end
  end
end
```

The goal is to make things a lot easier to build than with Jbuilder alone.   For example, above, it's much
easier to build the sections, items, and components without having to deal with child!, array!, or partials
with collections.  Which also makes it a lot easier to build arrays of heterogeneous components.

Building your data is a snap, too.  For example:

```ruby
head do
  title "Beatles"
  data.names ["John", "George", "Paul", "Ringo"]
  data.songs [
    {album: "My Bonnie", song: "My Bonnie"},
    {album: "My Bonnie", song: "Skinny Minnie"},
    {album: "Please Please Me", song: "I Saw Her Standing There"},
  ]
end
```

Some things get a lot less verbose

style blocks using hashes:

```ruby
head do
  title "Foobar"
  style "styled_row", font: "HelveticaNeue", size: 20, color: "#FFFFFF", padding: 10
  style "col", font: "RobotoBold", color: "#FF0055"
end
```

Produces:

```json
{
  "$jason": {
    "head": {
      "title": "Foobar",
      "styles": {
        "styled_row": {
          "font": "HelveticaNeue",
          "size": "20",
          "color": "#FFFFFF",
          "padding": "10"
        },
        "col": {
          "font": "RobotoBold",
          "color": "#FF0055"
        }
      }
    }
  }
}
```

You can even do the bare minimum head block like this:

```ruby
jason do
  head.title "Simple!"
  body do
    # Your Brilliant App
  end
end
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'jasonette-rails'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install jasonette
```

## Start using

### Write some Jasonette

`.jasonette` is a extension for any Jasonette templates/partials. 

### Formatting template(jason document)

Basic template looks like this,

```ruby
# application.jasonette
head do
  # ...
end
body do
  # ...
end
```

Template(Jasonette) just need `head` and `body` blocks. It results with `$jason`(default document name in jasonette) as root node by default for template.
Add any other document name. For Example,

```ruby
# application.jasonette
# head  block
# body block 
jason 'new document' do
  # ...
end
```

Every single word in block assume like method which play as key, and argument as value. 
And it makes each key pair easy to write.

```ruby
blue 'its a color'
# { "blue": "its a color" }
```

Easily to express any hard method to act as method. Use `set!`.

```ruby
set! 'color:disabled', '1000'
# { "color:disabled": '1000' }

set! 'color' do
  white 'W'
  black 'B'
end
# { "color": [{"white": "W"}, {"black": "B"}] }

set! 'color', [{ encode: 'W', name: 'white' }, { encode: 'B', name: 'black' }] do |color|
  set! color[:name], color[:encode]
end
# { "color": [{"white": "W"}, {"black": "B"}] }

set! 'color', { 'white'=>'W', 'black'=>'B' } do |color_name, encode|
  set! color_name, encode
end
# { "color": [{"white": "W"}, {"black": "B"}] }

set! 'color', [{ encode: 'W', name: 'white', type: 'color' }], :encode, :name
set! 'color', @colors, :encode, :name
# { "color": [{"encode": "W", "name": "white"}] }
```

Some more methods like `set!` which keep things simpler, like `inline`, `array!`, `merge!`

```ruby
# Add any JSON as inline in template,
head do
  title 'players'
  inline game: 'hockey', field: 'ice' 
end
# { "head": { "title": "players", "game": "hockey", "field": "ice" } }

array! ['hockey', { type: 'Game', name: 'Cricket' }, jasonette_obj]
# ["hockey", {"type": "Game", "name": "Cricket"}, { ... jasonette_obj attributes hash ... }]

array! @players, :id, :name
array! @players do |player|
  set! :id, player.id
  set! :name, player.name
end
# [{"id": "1", "name": "bro"}]

merge! jasonette_obj
merge! game: 'hockey', field: 'ice'
```

`merge!` also be used to yield your template in layout 

```ruby
# layouts/application.jasonette
merge! yield
```

Break jasonette template in to partials

```ruby
partial! 'matches', matches: @group.matches
``` 

Add styles, templates, data, actions in head by calling its relative singular method which clean all element separately.  

```ruby
head do
  style :button do
    # .... 
  end
  template :first do
    # ... 
  end
  datum :users do
    # ...
  end
  action :sign_in do
    # ...
  end
end
# { "head": { 
#      "styles":    { "button": ... }
#      "templates": { "first": ... }
#      "data":      { "users": ... }
#      "styles":    { "sign_in": ... }
#   }
# }
```

Action can be simplified with `render!`, `reload!`

```ruby
action do
  reload!
end
# { "action": { "type": "$reload" } }
```

Different component definitions

```ruby
label     'colors'
text      'yellow'
video     'http://youtube.com/watch?v={{ id }}'
image     'image_url'
button    'http://youtube.com/watch?v={{ id }}', true
button    'click'
layout    'horizontal' # Default vertical
textfield 'email', 'email ID' # default nil
textarea  'bio', 'player' # default nil
slider    'temperature', 10 # default nil
space     20
html      '<html></html>'
map # block...
```

This all component definitions also accepts block. And in result, It will add `type` by default,
 
```ruby
label 'Hello' do
  style do
    color '#fff'
  end
end
# { "type": "label", "text": "Hello", "style": { "color": "#fff" } }
```

### Rails helpers

Helpers will return a jasonette object. Which further can be used with core method like `set!`, `array!`, `merge!`

```ruby
label = component 'label', 'hello' do
  # ...
end

layout = layout 'horizontal' do
  # ...
end

set! "items", [label, layout]
```

You can also create some custom helpers using `jason_builder`. 
Argument be like any builder or builder class. Like :map, Jasonette::Body::Sections.
More you get following `lib/jasonette/core` folders

```ruby
jason_builder :style do
  # ...
end
```

### Some conventions to make things simpler.

* use `set!` when keys to be like reserve keywork in rails. 
* use `klass` to set `class` key 
* use `action_method` to set `method` key

```ruby
set! 'yield', 'strength'
# { "yield": "strength" }

klass 'disable'
# { "class": "disable" }

action do
  options do
    url 'login'
    action_method 'post'
  end
end
# { "action": { "options": { "url": "login", "method": "post" } } }
```

## Contributing

# How to contribute to Jasonette Rails

## **Do you have a bug report or a feature request?**

* **Ensure the bug was not already reported** by searching on GitHub under [Issues](https://github.com/mwlang/jasonette-rails/issues).

* If you're unable to find an open issue addressing the problem, [open a new one](https://github.com/mwlang/jasonette-rails/issues/new). Be sure to include a **title and clear description**, as much relevant information as possible, and a **code sample** or an **executable test case** demonstrating the expected behavior that is not occurring.

## **Did you write a patch that fixes a bug?**

If you find a bug **anywhere in the code**, or have any improvements anywhere else, please feel free to:

  1. Fork the project
  2. Create a feature branch (fork the master branch)
  3. Fix
  4. Send a pull request

* Ensure the PR description clearly describes the problem and solution. Include the relevant issue number if applicable.

* Please include specs that cover the issue.  PR will not be accepted without the relevant tests to support the change.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
