module SolutionsHelper

  # def quick_calculation(solution_id)
  #   numerator = 0
  #   denominator = 0

  #   Solution.find(solution_id).problem.criterium.each do |c|
  #     numerator += [0, c.user.count-c.cridissent.count].max * c.poll.where(solution_id: solution_id).average(:answer)
  #     denominator += c.user.count
  #   end

  #   return numerator / denominator
  # end

  def base_criterium_score(criterium_id)
    criterium = Criterium.find(criterium_id)

    if criterium.user.count == 0
      power = 0
    else
      power = (criterium.user.count - criterium.cridissent.count).to_f / criterium.user.count.to_f    
    end

    #don't let the score be negative
    if power < 0
      power = 0
    end

    return power
  end

  def problem_criteria_sponsor_count(solution_id)
    criteria = Solution.find(solution_id).problem.criterium
    result = 0
    criteria.each do |criterium|
      # if criterium has been polled, include its score
      if criterium.poll.where(solution_id: solution_id).count > 0
        # add to total sponsor count
        result += criterium.user.count
      end
    end
    result
  end

  # average score
  def solution_criterium_score(solution_id, criterium_id)
  	criterium = Criterium.find(criterium_id)
  	polls = criterium.poll.where(solution_id: solution_id)

    percent = polls.average(:answer)
    criterium_power = base_criterium_score(criterium_id)

    if percent == nil
    	0
    else
    	(percent * criterium_power).round(2)
  	end
  end

  def solution_score(solution_id)
  	solution = Solution.find(solution_id)
  	criteria = solution.problem.criterium

  	raw_score = 0
    denominator = 0


    criteria.each do |criterium|
      # if criterium has been polled, include its score
      if criterium.poll.where(solution_id: solution_id).count > 0
        # add average score wieghted by sponsorship
        raw_score += (solution_criterium_score(solution_id, criterium.id) * criterium.user.count)
        # number to divide by should result in a 0-1 decimal
        denominator += criterium.user.count
      end
    end

    return 0 if denominator == 0 # don't divide by zero

    # not adjusted to weigh sponsors
  	# criteria.each do |criterium|
  	# 	raw_score += solution_criterium_score(solution_id, criterium.id)
    #   count += 1 if criterium.poll.where(solution_id: solution_id).count > 0
  	# end

  	(raw_score / denominator).round(2)
  end
end
