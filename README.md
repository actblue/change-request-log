Change Request Log
==================

This repository can be used to track changes to multiple projects in a
PCI-compliant environment. It allows you to use different deployment methods
for each project, but keep track of all of them in one place.

Each project (i.e. a web application, a configuration management setup, or a
description of physical hardware) should be added to your fork of this
repository as a submodule.

When you want to make a change, commit an update to the relevant submodule. A
rake task is provided to make this more convenient. This repository's commit
hook will create a template for you to fill in a description of the change.
Then, someone else can approve the change by merging it.

You can also use this repository to log changes made to projects that are not
in PCI scope. If you choose to disable the full change request template for a
project, the hook will only include a short log of changes in the commit
message.

How To Use This Repository
==========================

(For everything below, bits of code in `ALL_CAPS` are placeholders for values
that you should fill in.)

Before doing anything, run:

    rake setup
    bundle install

Currently, `bundle` only installs `hub`; you can also just
[get the standalone version](https://github.com/defunkt/hub#standalone).

If you are starting from scratch, and not cloning your organization's existing
fork, add a submodule for each of your projects with:

    rake add[URL,PATH]

`PATH` is optional. To update an existing project and create a change request,
run:

    rake update[SUBMODULE,REV]

`REV` defaults to `master`. This does roughly the following behind the
scenes, in case you need to do it yourself:

    git checkout -b req-UNIQUENAME
    cd SUBMODULE
    git pull
    cd ..
    git add SUBMODULE
    git commit

It then uses `hub` to create a pull request (using a branch in the original
repo, rather than a fork). If you have another merge workflow (e.g. email and
`git am`), this could be made optional -- patches welcome!

Non-PCI Projects (experimental)
===============================

To suppress the full change request template for a project, set the
repository's config option `submodule.SUBMODULE.suppress-template` to `true`.
There is no convenient interface for this yet because it's currently not
possible to store this option in `.gitmodules`. I am open to suggestions.

Recommendations
===============

Whatever merge workflow you use, you must produce a merge commit to record who
approved a change. If merging from the command line, remember to

    git merge --no-ff

So that git does not do a fast-forward merge. A server-side hook could be
created to enforce this.

Do not create your own topic branches in this repository. There is only one
state of the world at any given time. If you fork the timeline, your pies may
burn.

Commit Message Format
=====================

The important metadata (author, etc) is stored in the commit itself. Commit
messages created with this repository's hooks will consist of a summary line
followed by a chunk of Markdown. Theoretically, this should be machine
parsable.

I plan add a script that will generate a PDF from each commit, that could be
run from another hook on a successful merge.

License
=======

This repository framework is released under the MIT license (see the file
`LICENSE` for details). Obviously, it is intended to be used to store private
information. Please remember that the license, like all Free software
licenses, says that you *may* redistribute derived works under certain
conditions, not that you *must* do so.
