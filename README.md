# Jasonette Rails
A extension of the Jbuilder framework to facilitate building Jasonette flavored JSON in Rails

## ALPHA code!

Warning:  This project is **alpha** code and still in highly experimental stage and subjected to
drastic changes to the DSL.  It is also quite full of bugs despite the unit tests you may find herein!

Note: Almost nothing about this gem is documented, however, you can find ample examples in the project's
spec/lib/jasonette/... folders.  Generally speaking, the DSL follows the $jason structure closely and supporting
classes are organized in sub-folders of the project's lib/jasonette/... accordingly.

### Here lies trouble!

* There is limited support for breaking apart giant jbuilder templates into smaller partials.  Right now, there's
just two "hooks" into the Jbuilder library and that's "json.jason" and "json.body"

* asset_paths don't quite work.  For example, image_url('some_image.png') only yields a relative path and w/o fingerprint.

* not all components are represented, yet.  layouts, labels, images, but not button, textfield, textarea, etc.

* Templates, mixins, etc. are not yet built.

* When you introduce structural errors, the error may be cryptic, basically showing only "failed to load with I/O error reported"

### TODO

* implement all the Jasonette components
* implement Templates, Mixins, etc.
* fix asset Helpers
* better error detection and handling
* refining implementation in the various classes
* document
* add Linting?

## Usage

This gem allows to to write the JSON structure expected by a Jasonette application in a much more powerful
way than with Jbuilder alone.

For example:

Here's how the "hello.json" demo JSON would be rendered with this gem:

```ruby
json.jason do
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
end
```

Since it is hooked into Jbuilder, you're able to mix and match Jbuilder directives alongside the extensions provided
through this gem.  

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
