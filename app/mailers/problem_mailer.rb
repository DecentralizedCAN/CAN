class ProblemMailer < ApplicationMailer
  
  def new_problem(problem)
    if Setting.find(8).state
	    @problem = problem
	    
	    users = User.all

	    mail(
	      bcc: users.map(&:email).uniq, 
	      subject: "New goal"
	    )
	end
  end

end