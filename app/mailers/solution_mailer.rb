class SolutionMailer < ApplicationMailer

  def new_solution(solution)
    @solution = solution
    
    users = @solution.problem.user

    mail(
      bcc: users.map(&:email).uniq, 
      subject: "New proposal"
    )
  end

end