Change Request Log
==================

This repository is a tool for tracking changes to multiple projects in a
PCI-compliant environment. It allows you to use different deployment methods
for each project, but keep track of all of them in one place. Git's built-in
integrity guarantees ensure that your history has not been tampered with.

Each project (such as a web application, a configuration management setup, or
a description of physical hardware) should be added to your fork of this
repository as a submodule.

When you want to make a change, commit an update to the relevant submodule. A
rake task is provided to make this more convenient. This repository's commit
hook will create a template for you to fill in a description of the change.
Then, someone else can approve the change by merging it.

The history of this repository, once you start committing to it, will
conceptually be composed of pairs of commits: a change (to one or more of your
submodules), with the change description stored in the commit message, and a
merge, storing the identity of who approved it. This history can then be used
as you see fit to demonstrate your PCI compliance.

Forking
=======

If you're joining an organization that already uses this repository, you can
skip this section; just clone your private fork.

If you're getting started: normally, to make your own copy of someone's
repository on GitHub and start making your own changes, you'd click the "fork"
button above. However, GitHub does not (as of 2013) support forking to a
private repository. If you want to keep your information private, you'll need
to create your own private repository first. Then, clone this repository and
set up your local clone to use your fork:

(For all code examples below, words in `ALL_CAPS` are placeholders for values
that you should fill in.)

    git clone https://github.com/actblue/change-request-log.git
    cd change-request-log
    git remote rename origin public
    git remote add origin git@github.com:YOUR_ORGANIZATION/YOURORG-change-request-log.git
    git push -u origin master

There are several ways to do this, but we recommend leaving the official
public repository as a remote called `public`. If a feature or bug fix is
added here, you can then run

    git fetch public
    git merge public/master

To merge in new public commits. If you want to contribute to the public
code, you can of course also create a public fork first, and use that as
the basis of your private fork.

How To Use This Repository
==========================

Once you've set up your local clone, run:

    rake setup
    bundle install

Currently, this repository's bundle just installs `hub`; you can also simply
[get the standalone version](https://github.com/defunkt/hub#standalone).

To add a submodule for one of your projects:

    rake add[URL,DIR]

`DIR` is optional, and defaults to what `git clone` would create.

To update an existing project and create a change request, run:

    rake update[SUBMODULE,REF]

`REF` defaults to `master`, but can be any branch, tag, or revision. This does
roughly the following behind the scenes, in case you need to do it yourself:

    git checkout -b req-SOME_UNIQUE_NAME
    (cd SUBMODULE && git pull)
    git add SUBMODULE
    git commit

It then uses `hub` to create a pull request in your `origin` repository. If
you have another merge workflow (e.g. email and `git am`), this could be made
configurable -- patches welcome!

If you want to pass additional options to `git pull`, export the environment
variable `PULL_OPTIONS`. For example,

    export PULL_OPTIONS='--ff-only'

would ensure you don't create any new merge commits inside the submodule.

The Template
============

Commit messages are filled in from `config/commit-message-template.erb`,
an ERb template. Do review the outline under "Change Description" there
and edit it to fit your needs before using this repository; the one
shipped here is just a very general example. It may not cover everything
you want to document in your change requests.

Commit Message Format
=====================

The important metadata (author, etc) is stored in the commit itself. Commit
messages created with this repository's hooks will consist of a summary line
followed by a chunk of Markdown. Theoretically, this should be machine
parsable.

I plan add a script that will generate a PDF from each commit, that could be
run from another hook on a successful merge.

Recommendations
===============

Whatever merge workflow you use, you must produce a merge commit to record who
approved a change. If merging from the command line, remember to

    git merge --no-ff

So that git does not do a fast-forward merge. A server-side hook could
be created to enforce this (assuming that you are using a non-GitHub
server).

In Git, a given ref uniquely identifies the history up to that point, but the
individual commits that make up that history are not authenticated. The
recommended way to handle this is to create signed tags (e.g. at your annual
PCI review).

Do not create your own topic branches in this repository apart from individual
change requests to be merged into `master`. There is only one state of the
world at any given time. If you fork the timeline, your pies may burn.

Non-PCI Projects (experimental)
===============================

You can also use this repository to log changes made to projects that are not
in PCI scope. If you choose to disable the full change request template for a
project, the hook will only include a short log of changes in the commit
message.

To suppress the full change request template for a project, set the
repository's config option `submodule.SUBMODULE.suppress-template` to `true`.
There is no convenient interface for this yet because it's currently not
possible to store this option in `.gitmodules`. I am open to suggestions.

License
=======

This repository framework is released under the MIT license (see the file
`LICENSE` for details). Obviously, it is intended to be used to store private
information. Please remember that the license, like all Free software
licenses, says that you *may* redistribute derived works under certain
conditions, not that you *must* do so.

Decklin Foster <decklin@actbluetech.com> is to blame for this idea. He
enjoys using Git for odd things and would like to hear your experiences.
