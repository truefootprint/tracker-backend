class Banding
  def band(rank, count)
    return unless rank
    percent = rank.to_f / count * 100

    if percent < 20
      1
    elsif percent < 50
      2
    elsif percent < 70
      3
    else
      4
    end
  end
end
