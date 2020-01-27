class SolutionMailer < ApplicationMailer

  def new_solution(solution)
    if Setting.find(8).state
	    @solution = solution
	    
	    users = @solution.problem.user

	    mail(
	      bcc: users.map(&:email).uniq, 
	      subject: "New proposal"
	    )
	end
  end

end