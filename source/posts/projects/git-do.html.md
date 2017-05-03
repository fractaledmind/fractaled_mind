---
title: git-do
date: 2015-07-25
image: projects/git-do.svg
github: https://github.com/smargh/git-do
tags:
  - code>git
  - code>bash
summary: Pre-emptive git commit messages.
---
#### Version 0.1

#### Download on [GitHub](https://github.com/smargh/git-do)

**`git-do`** is a [Git](https://git-scm.com/) extension that adds a new perspective to the standard Git workflow. I conceive of it as a promises-based workflow.

To better explain, let me begin by laying out the default Git workflow:

  + You start working on a new feature/fix/item
  + Maybe you create a new branch for this feature to live in
  + You get in the flow and knockout the feature in 1 hour
  + You realize you should commit some of this great workflow
  + You want your commit history to be clean and readable, so you want to chunk your work into logical commits
  + So, you use `git status` and `git diff` to figure out which changes/additions/deletions should live together in a single commit
  + This whole time, your mind is running forward, thinking of the next thing you *actually want to code*

This general flow happens to me almost every time I code. I'm future oriented, always thinking about what's next. So, few things bog me down quite like having to stop after writing code only to retroactively document what I've done. This is Git's default point-of-view: backwards-facing, past-oriented. You can only commit *after* you've done some work.

Now, of course, this makes good sense. How could you commit nothing? You need to have done something in order to commit it. Yes, but committing is more than simply adding your work to the Git history; committing is also directly tied to documenting, describing, and summarizing your work. As many developers have argued, commit messages explain *why* the changes are there (diffs explain *what* changed).

In an intriguing and well-written [blog post](https://arialdomartini.wordpress.com/2012/09/03/pre-emptive-commit-comments/), Arialdo Martini suggests that pre-emptive commit messages confer a number of benefits:

  1. More focus while developing
  2. Commit review is easier
  3. Less cognitive load
  4. More precise comments
  5. Declaration of intent
  6. Triggers micro design session
  7. Sets a micro goal
  8. Creates a little timebox
  9. Commit history gains balanced granularity

I heartily recommend that you read the entire post and wrestle with Arialdo's points yourselves; I, for one, think he's on to something. Pre-emptive commit messages have become, for me, something akin to micro [feature branches]().

When using feature branches, you necessarily are pre-planning what all the feature entails, how best to describe/name it, and what it looks like to complete said feature. Pre-emptive commit messages are conceptually the same thing, just on a smaller scale. In addition to considering what an entire feature entails, you consider what your next commit will entail *before you start writing any code* for that commit. This method of working forces you to [know your next commit](http://programmer.97things.oreilly.com/wiki/index.php/Know_Your_Next_Commit).

As a co-developer pointed out, this is really just taking the philosophy of Test-Driven Development (TDD) and enforcing it's mental model even at the commit level (conceptually, the commit is the atomic unit of Git). Everything you do, you do with purpose. You declare your intention before you begin. You know exactly what the code needs to do for this commit to be ready. You make a promise with yourself.

- - -

The actual api for **`git-do`** is utterly simple. Before you start your next task (by "task" here I mean whatever you conceive of as your smallest unit of work), you run `git do "<message>"`. As soon as you have completed your task, you run `git done`. That's it!

Under the hood **`git-do`** is doing a few things. First, it will save your commit message to a temporary file (in a created `.git/.git-do/` directory) as well as the name of whatever branch you are on when you run the `git do` command. It will then create and checkout a new branch (using the naming schema `do/<slugify(message)>`). **`git-do`** checkouts out a new branch so that you have a safe "sand-box" to do your work, allowing you to leave if something urgent comes up (e.g. you need to create a hotfix branch from master and solve a critical problem). This branch, however, will be deleted as soon as you run `git done`, so you should always think of it and treat it as a temporary branch.

As you do your work in the `do/` branch, you need not commit anything. Remember, **`git-do`** exists at the level of the individual commit. If you think you want to use **`git-do`**, but think you will probably have multiple commits, create a feature branch instead. Once you have finished whatever constitutes your commit, you run `git done`. This will stage and commit all of the changes made in the `do/` branch. It will use the message your wrote for `git do` as the actual commit message. It will then checkout the `do/` branch's parent branch and merge that one commit. This merge must be a [fast forward merge](), which means you can't have changed or done anything in the parent branch after running `git do` but before running `git done` (Again, anything you do using **`git-do`** should fit in one commit and should be your branch's next commit. Don't let the fact that **`git-do`** creates a temporary branch lull you into thinking you should treat your work there as anything but a single, simple commit).

After merging your commit into the original parent branch, `git done` will delete the `do/` branch. So, if you have a terminal prompt that doesn't specify the current branch, you would never know the `do/` branch ever existed. Your commit history would look exactly as it would had you done the work and written the commit message at the end.

Below is a (contrived) example to demonstrate how simple and short I believe the workflow ought to be:

~~~bash
$ git do "Demonstrate how git-do works for my project page"
$ touch demonstration.txt
$ vi demonstration.txt
$ git done
~~~
