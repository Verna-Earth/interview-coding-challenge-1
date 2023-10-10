alias Bullet.Journal
alias Bullet.Journal.Goal
alias Bullet.Journal.GoalRecord

goal_attr1 = %{id: 33, description: "jump jump", goal_type: :yesno_goal}
goal_attr2 = %{id: 34, description: "jump jump", goal_type: :numeric_goal}

Goal.changeset(%Goal{}, goal_attr2)

goal_record_attr1 = %{record_date: "2023-10-08", completed_score: 40, goal: %{id: 270}}

goal_record_attr2 = %{
  id: "abba9413-96b7-4a21-afef-91fc1c625c4c",
  record_date: "2023-10-08",
  completed_score: 1,
  goal_id: "bfd89413-96b7-4a21-afef-91fc1c625c4c"
}
GoalRecord.changeset(%GoalRecord{}, goal_record_attr2)

# insert old data
[pizza, talk, pancake | _] = Journal.list_goals |> Enum.to_list
Journal.create_goal_record(%{record_date: "2023-10-08", completed_score: 5, goal_id: talk.id})
Journal.create_goal_record(%{record_date: "2023-10-07", completed_score: 4, goal_id: talk.id})
Journal.create_goal_record(%{record_date: "2023-10-06", completed_score: 3, goal_id: talk.id})
Journal.create_goal_record(%{record_date: "2023-10-05", completed_score: 6, goal_id: talk.id})
Journal.create_goal_record(%{record_date: "2023-10-04", completed_score: 10, goal_id: talk.id})
Journal.create_goal_record(%{record_date: "2023-10-03", completed_score: 1, goal_id: talk.id})
Journal.create_goal_record(%{record_date: "2023-10-02", completed_score: 20, goal_id: talk.id})
Journal.create_goal_record(%{record_date: "2023-10-01", completed_score: 3, goal_id: talk.id})

Journal.create_goal_record(%{record_date: "2023-10-07", completed_score: 1, goal_id: pizza.id})
Journal.create_goal_record(%{record_date: "2023-10-05", completed_score: 1, goal_id: pizza.id})
Journal.create_goal_record(%{record_date: "2023-10-03", completed_score: 1, goal_id: pizza.id})
Journal.create_goal_record(%{record_date: "2023-10-01", completed_score: 3, goal_id: pizza.id})

Journal.create_goal_record(%{record_date: "2023-10-06", completed_score: 10, goal_id: pancake.id})
Journal.create_goal_record(%{record_date: "2023-10-04", completed_score: 1, goal_id: pancake.id})
Journal.create_goal_record(%{record_date: "2023-10-02", completed_score: 20, goal_id: pancake.id})