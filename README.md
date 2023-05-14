# Verna interview coding exercise

This repo is the basis for one of the coding exercises for applicants to
engineering job vacancies at [Verna](https://verna.earth). This exercise
emphasises front-end web application coding.

The goal of this exercise is to give us an idea of your coding style, and
something to discuss during the technical part of the interview. We'd hope for
this exercise to take something in the region of three or four hours. Please,
don't spend your entire weekend on this challenge. It's not necessary to meet
the goals of the interview process, and, frankly, you've got much more
interesting things to do in your free time!

## Instructions

If you are a GitHub user:

1. `git clone` this repo.
2. Write a small but functionally-complete app that meets the brief, below.
   Make as many commits as you normally would do.
3. Include a document to explain how the reviewer can run your app.
4. Create a pull-request to merge your solution back to `main`.

If you're not a GitHub user, or your GH account is private:

1. Your hiring manager will send you a `.zip` or `.tar` file containing
   this exercise.
2. Write a small but functionally-complete app that meets the brief, below.
   Make as many commits as you normally would do.
3. Include a document to explain how the reviewer can run your app.
4. Zip or tar your solution, and email it to your hiring manager.

## The brief

Our new product idea is a variant of a daily
[bullet journal](https://en.wikipedia.org/wiki/Bullet_journal).
We want to create a simple prototype for user testing.

The bullet journal app will be a web application in which users can:

- set daily goals
- a goal can be either a yes/no option (e.g. "Go for a walk every day")
  or a numerical option (e.g. "practice speaking French for at least
  10 mins every day")
- each day, enter whether they have met the goal or not
- at any time, see some simple reports of progress against goals.

### User stories

Here are some initial user stories, with
[MoSCoW](https://en.wikipedia.org/wiki/MoSCoW_method) priorities:

**M** When I am using the app<br />
I want to quickly record when I have met a current yes/no goal<br />
So that it's easy for me to track my progress each day.

**M** When I am using the app<br />
I want to quickly record the amount I have completed for a numerical goal<br />
So that it's easy for me to track my progress each day.

**C** When I am using the app<br />
I want to amend a previous day's daily goals<br />
So that I can keep my progress up-to-date even if I forgot at the time.

**M** When I have a new goal that I want to set myself<br />
I can create a new daily target in the app<br />
So that it's easy for me to set new objectives for myself.

**M** When I am looking at reports from the app<br />
I can see my progress against recent daily goals<br />
So that I can tell if I'm succeeding at meeting my goals.

**C** When I am looking at reports from the app<br />
I can see my progress aggregated as weekly averages<br />
So that I can tell if I'm succeeding at meeting my goals.

### Tech stack and design

This is entirely up to you. At Verna, we're using
[Elixir](https://elixir-lang.org/) and
[Phoenix](https://hexdocs.pm/phoenix/overview.html) for these sorts of
applications. But you don't have to use that stack if you don't want to - use
something you're comfortable with.

Likewise, we haven't given you any wireframes. Feel free to be as
creative as you like, but primarily this is a coding challenge not a
design challenge.

### Keeping it simple

This is just a coding exercise. We want to keep things simple. So:

- don't worry about persistent data storage. Feel free to use a JSON file, or
  local storage in the browser, as the data store
- don't worry about adding user authentication - assume a fixed user name or
  email if you need one
- feel free to create some synthetic historical data to simulate the user having
  used the app for a few days or weeks (otherwise the reporting feature won't be
  very interesting!)
- if there are interesting challenges that you anticipate but don't have time to
  deal with in the scope of this challenge, feel free to document next steps in
  a `todo.md` note.
- there's no need to deploy your solution to a platform like Vercel, unless you
  really want to!

## Note on using AI coding tools

At Verna, we don't use AI tools like Co-pilot or GTP3 to write code. So, we're
asking you not to do that in this challenge. If you feel that using an AI to
help write code is the way you want to work, please discuss it with your hiring
manager first.
