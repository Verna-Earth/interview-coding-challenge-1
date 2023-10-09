alias Bullet.Journal
alias Bullet.Journal.Goal
alias Bullet.Journal.GoalRecord

goal_attr1 = %{id: 33, description: "jump jump", goal_type: :yesno_goal}
goal_attr2 = %{id: 34, description: "jump jump", goal_type: :numeric_goal}

Goal.changeset(%Goal{}, goal_attr2)

goal_record_attr1 = %{record_date: "2023-10-08", completed_score: 40, goal: %{id: 270}}

goal_record_attr2 = %{
  record_date: "2023-10-08",
  completed_score: 1,
  goal: %{id: "bfd89413-96b7-4a21-afef-91fc1c625c4c"}
}

GoalRecord.changeset(%GoalRecord{}, goal_record_attr2)
