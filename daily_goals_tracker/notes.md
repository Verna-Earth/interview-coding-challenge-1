# TODO

* Handle time zones currently just using UTC for the day.
* Pagination for achievements and goals list.
* Use of a global requires tests to be synced, refactor to enable the use of the store concurrently.
* Pass a seed function to the sore to deffer generating seeds so the generated seed is not passed to the store process.
* Support sorting the achievements, goals and reports tables by columns.
* When a goal is removed also remove the orphaned achievements in the store.
* Use persistence like db for store.