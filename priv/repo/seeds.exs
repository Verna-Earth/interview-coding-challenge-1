# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ToDo.Repo.insert!(%ToDo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

ToDo.Repo.insert!(%ToDo.User{name: "Judith", email: "lacks_imagination@hotmail.com"})

ToDo.Repo.insert!(%ToDo.Task{
  name: "Language lessons",
  task_type: :bool,
  frequency: 1,
  user_id: 1
})

ToDo.Repo.insert!(%ToDo.Task{name: "Stretches", task_type: :times, frequency: 3, user_id: 1})

ToDo.Repo.insert!(%ToDo.Task.Record{
  task_id: 1,
  completed: Date.utc_today() |> Date.add(-1),
  times: 1
})

ToDo.Repo.insert!(%ToDo.Task.Record{
  task_id: 2,
  completed: Date.utc_today() |> Date.add(-1),
  times: 2
})

ToDo.Repo.insert!(%ToDo.Task.Record{
  task_id: 2,
  completed: Date.utc_today() |> Date.add(-2),
  times: 4
})
