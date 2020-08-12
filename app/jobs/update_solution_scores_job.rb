class UpdateSolutionScoresJob < ApplicationJob
  queue_as :default
  include SolutionsHelper

  def perform(problem_id)
    solutions = Problem.find(problem_id).solution.all

    if Problem.find(problem_id).facilitator_id
      solutions.each do |solution|
        # polls = Poll.joins(:user).group("poll.id").where(solution_id: solution.id)
        polls = Poll.where(solution_id: solution.id)

        if polls.count > 0 
          score = (polls.average(:answer) * 100).round
        else
          score = 0
        end
        solution.update( :score => score )
      end
    else
      solutions.each do |solution|
        solution.update(:score => solution_score(solution.id) * 100)
      end
    end
  end
end
