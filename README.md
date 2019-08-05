# Contributing to the documentation

ZAP documentation is built using [Slate](https://github.com/tripit/slate).


## Editing documentation content

All documentation is in `includes` directory, and uses Markdown text format,
plus some Slate widgets (such as notices).


## Preview changes

Once some changes have been done, Slate needs to build HTML sources from Markdown files.

First, install bundler using `apt-get install bundler` or `gem install bundler`. Make sure you've also installed ruby's header to build the json package.
On ubuntu 18:
```
sudo apt install ruby-bundler ruby2.5-dev
```

Then check that Slate dependencies are installed:

``` bash
cd documentation/slate
bundle install
```

Then build the documentation:

``` bash
cd documentation/slate
bundle exec middleman build
```
