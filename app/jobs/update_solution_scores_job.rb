class UpdateSolutionScoresJob < ApplicationJob
  queue_as :default
  include SolutionsHelper

  def perform(problem_id)
    solutions = Problem.find(problem_id).solution.all
    problem = Problem.find(problem_id)

    if problem.scoring_method && problem.scoring_method != 1
      solutions.each do |solution|
        polls = Criterium.where(problem_id: problem_id).joins(:user).joins(:poll).where('"polls".solution_id': solution.id)
        # polls = Poll.joins(:user).group("id").where(solution_id: solution.id)
        # polls = Poll.where(solution_id: solution.id)

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
