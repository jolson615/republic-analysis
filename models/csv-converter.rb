def to_nested(raw_data)
  rows = raw_data.split('\r\n')
  rows.collect! do |row|
    row.split(",")
  end
  column_count = rows[0].count
  puts rows[1].join(",")
  puts rows[1]
  rows
end
