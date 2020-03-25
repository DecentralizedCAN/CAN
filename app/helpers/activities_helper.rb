module ActivitiesHelper
  def total_minimum(action)
    total = 0

    action.roll.each do |role|
      total += role.minimum
    end

    total
  end

  def total_maximum(action)
    total = 0

    action.roll.each do |role|
      if role.maximum
        total += role.maximum 
      else
        return nil
      end
    end

    if total > total_minimum(action)
      total
    else
      nil
    end

  end

  def total_committed(action)
    total = 0

    action.roll.each do |role|
      total += role.user.count
    end

    total
  end
end
