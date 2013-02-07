# Hi there!

I see you are interested in contributing. That is wonderful. I love
contributions.

I guarantee that there are bugs in this software. And I guarantee that there is
a feature you want that is not in here yet. As such, any and all bugs reports
are gratefully accepted, bugfixes even more so. Helping out with bugs is the
easiest way to contribute.


## The Quick Version

* Have a [GitHub Account][].
* Search the [GitHub Issues][] and see if your issue already present. If so
  add your comments, :thumbsup:, etc.
* Issue not there? Not a problem, open up a [new issue][].
    * **Bug reports** please be as detailed as possible. Include:
        * full ruby engine and version: `ruby -e 'puts RUBY_DESCRIPTION'`
        * operating system and version
        * version of hitimes `ruby -rubygems -e "require 'hitimes'; puts Hitimes::VERSION"`
        * as much detail about the bug as possible so I can replicated it. Feel free
          to link in a [gist][]
    * **New Feature**
        * What the new feature should do.
        * What benefit the new feature brings to the project.
* Fork the [repo][].
* Create a new branch for your issue: `git checkout -b issue/my-issue`
* Lovingly craft your contribution:
    * `rake develop` to get started, or if you prefer bundler `rake develop:using_bunder && bundle`.
    * `rake test` to run tests
* Make sure that `rake test` passes. Its important, I said it twice.
* Add yourself to the contributors section below.
* Submit your [pull request][].

# Contributors

* Jeremy Hinegardner

[GitHub Account]: https://github.com/signup/free "GitHub Signup"
[GitHub Issues]:  https://github.com/copiousfreetime/hitimes/issues "Hitimes Issues"
[new issue]:      https://github.com/copiousfreetime/hitimes/issues/new "New Hitimes Issue"
[gist]:           https://gist.github.com/ "New Gist"
[repo]:           https://github.com/copiousfreetime/hitimes "hitimes Repo"
[pull request]:   https://help.github.com/articles/using-pull-requests "Using Pull Requests"
