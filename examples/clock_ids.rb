def potential_clock_ids
  [].tap do |clock_ids|
    %i[
      CLOCK_MONOTONIC_RAW
      CLOCK_UPTIME_RAW
      CLOCK_MONOTONIC
      CLOCK_MONOTONIC_FAST
      CLOCK_REALTIME
    ].each do |c|
      clock_ids << { name: c, value: Process.const_get(c)} if Process.const_defined?(c)
    end
  end
end

clock_ids = potential_clock_ids
puts "Using the following clock ids: #{clock_ids.join(', ')}"

def resolutions_of(clock_id)
  counts = Hash.new(0)
  10_000.times do
    val = Process.clock_gettime(clock_id, :nanosecond)
    res = if (val % 1_000_000_000).zero?
            1
          elsif (val % 1_000_000).zero?
            1e-3
          elsif (val % 1_000).zero?
            1e-6
          else
            1e-9
          end
    counts[res] += 1
  end
  counts
end

data = { platform: RUBY_PLATFORM, clock_ids: {} }

clock_ids.each do |clock_info|

  name        = clock_info[:name]
  clock_id    = clock_info[:value]
  resolutions = resolutions_of(clock_id)

  data[:clock_ids][name] = resolutions.transform_keys(&:to_s)
end

require 'yaml'
puts YAML.dump(data)


