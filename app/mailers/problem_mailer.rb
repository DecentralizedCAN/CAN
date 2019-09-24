class ProblemMailer < ApplicationMailer
  
  def new_problem(problem)
    @problem = problem
    
    users = User.all

    mail(
      bcc: users.map(&:email).uniq, 
      subject: "New goal"
    )
  end

end