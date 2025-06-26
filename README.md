# Verna front-end coding challenge

This repo is the basis for one of the coding exercises for applicants to engineering job vacancies at [Verna]. This exercise emphasises front-end web application coding.

The goal of this exercise is to give us an idea of your coding style, and something to discuss during the technical interview. We'd hope for this exercise to take something in the region of three or four hours. We won't be checking, but please - don't spend your entire weekend on this challenge. It's not necessary to meet the goals of the interview process, and, frankly, you've got much more interesting things to do in your free time! It's fine to submit an incomplete solution with notes on what you would do with more time.

## Instructions

First agree a submission deadline with your hiring manager. This is intended to allow you time to fit in working on the challenge around your current work and home responsibilities.

If you are a GitHub user:

1. `git clone` this repo.
2. Write a small but functionally-complete app that meets the brief, below. Make as many commits as you normally would do.
3. Include a document to explain how the reviewer can run your app.
4. Create a pull-request to merge your solution back to `main`. Or, alternatively, send a link to the GitHub repo containing your solution.

If you're not a GitHub user, or your GitHub account is private:

1. Your hiring manager will send you a `.zip` or `.tar` file containing   this exercise.
2. Write a small but functionally-complete app that meets the brief, below. Make as many commits as you normally would do.
3. Include a document to explain how the reviewer can run your app.
4. Zip or tar your solution, and email it to your hiring manager.

## The brief

Our new product idea is a variant of a daily recurring-goals tracker. This is distinct from a standard todo-list, of which there are many, by allowing the user to set up a list of goals they expect to repeat every day. For example "take my meds", "practise a language", "do 20 pushups every day", etc. We want to create a simple prototype for user testing.

The daily-goals journal app will be a web application in which users can:

- set daily goals, which can be either a yes/no option (e.g. "Go for a walk every day") or  a numerical option (e.g. "practice speaking French for at least 10 mins every day")
- each day, enter how well they have done that day against the goal
- at any time, see some simple reports of progress against goals.

### User stories

Here are some initial user stories, roughly in priority order:

When I am recording my progress for today<br />
I want to quickly record when I have met a current yes/no goal<br />
So that it's easy for me to check off my daily todo items.

When I am recording my progress for today<br />
I want to quickly record the amount I have completed for a numerical goal<br />
So that it's easy for me to accumulate my progress each day.

When I have a new goal that I want to set myself<br />
I can create a new daily target in the app<br />
So that it's easy for me to set new objectives for myself.

When I am recording my progress for today<br />
I want to quickly amend the amount I have completed for a numerical goal<br />
So that it's easy for me to incrementally track my progress.

When I am looking at reports from the app<br />
I can see my progress against recent daily goals<br />
So that I can tell if I'm succeeding at meeting my goals.

When I am recording my progress for today<br />
I want to set an amount that exceeds my target for the day<br />
So that I can tell if I need to increase my goal.

When I am reflecting on previous days<br />
I want to amend a previous day's daily goal results<br />
So that I can keep my progress accurate even if I forgot at the time.

When I am looking at reports from the app<br />
I can see my progress aggregated as weekly averages<br />
So that I can tell if I'm succeeding at meeting my goals.

### Keeping it simple

This is just a coding exercise. We want to keep things simple. So:

- you are welcome to make any reasonable choice about data storage. Feel free to use a JSON file, or ephemeral storage in the app, as the data store, or to use a persistent database (such as Postgres) if you prefer
- don't worry about adding user authentication - assume a fixed user name or email if you need one
- feel free to create some synthetic historical data to simulate the user having used the app for a few days or weeks (otherwise the reporting feature won't be very interesting!)
- if there are interesting challenges that you anticipate but don't have time to deal with in the scope of this challenge, feel free to document next steps in a `todo.md` note.
- there's no need to deploy your solution to a platform like Vercel or Fly.io

## Implementation technology

We're using Elixir and Phoenix as the core of our stack at Verna, so that is the preferred choice. However, if you would really prefer to work in another language or framework, that's OK (but let us know ahead of time please).

Your solution should include instructions on how to build, launch and test your version of the app.

We haven't given you any wireframes. Feel free to be as creative as you like, but primarily this is a coding challenge not a design challenge.

## How we'll evaluate your solution

The key goal for this exercise is for you to show us how you think about, design, write and test code. There's a lot of moving pieces to this challenge. It's OK to do less of it in the time available, and focus on showing your best work. In fact, we'd prefer that you do some of it really well, than complete all of it but in rush and by cutting corners. Think about what skills you want to be able to demonstrate. As to what to leave out and what to include, that's up to you.

In terms of evaluation, we want you to show how you can create clean, clear implementations that would allow you and your colleagues to develop, ship and maintain effective, usable features over the long term.

## And lastly …

We can't check if you use AI tools like Copilot or GPT to complete this challenge, but please don't. That's not the way that we work at Verna, and we will want to discuss your design choices with you!

Once you have completed the exercise please either create a PR against the repo, or send your hiring manager an archive of your project.

Good luck!

[Verna]: https://verna.earth
