class UpdateSolutionScoresJob < ApplicationJob
  queue_as :default
  include SolutionsHelper

  def perform(problem_id)
    solutions = Problem.find(problem_id).solution.all
    solutions.each do |solution|
      solution.update(:score => solution_score(solution.id) * 100)
    end
  end
end
