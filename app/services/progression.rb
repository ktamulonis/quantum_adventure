class Progression
  LEVEL_THRESHOLDS = { 1 => 0, 2 => 250, 3 => 750, 4 => 1_500, 5 => 2_500 }.freeze

  def self.level_for(xp)
    LEVEL_THRESHOLDS.select { |_level, threshold| xp >= threshold }.keys.max
  end

  def self.next_threshold_for(xp)
    LEVEL_THRESHOLDS.values.find { |threshold| threshold > xp }
  end
end
