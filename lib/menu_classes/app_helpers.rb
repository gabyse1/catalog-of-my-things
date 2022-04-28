module AppHelpers
  def self.select_valid_option(option, first, last)
    until option == 'n' || (option.to_i >= first && option.to_i <= last)
      print 'Please enter a valid option: '
      option = gets.chomp.strip.downcase
    end
    option.to_i
  end

  def self.select_valid_item_option(option, first, last)
    until option == 'c' || (option.to_i >= first && option.to_i <= last)
      print 'Please enter a valid option: '
      option = gets.chomp.strip.downcase
    end
    option.to_i
  end

  def self.valid_state_input(request_text)
    input = ''
    print "#{request_text}: "
    input = gets.chomp.to_s.strip.downcase
    until input == 'good' || input == 'bad'
      print 'Please enter GOOD or BAD option: '
      input = gets.chomp.to_s.strip.downcase
    end
    input
  end

  def self.valid_bool_input?(request_text)
    input = ''
    print "#{request_text}: "
    input = gets.chomp.to_s.strip.downcase
    until input == 'y' || input == 'n'
      print 'Please enter Y or N option: '
      input = gets.chomp.to_s.strip.downcase
    end
    input == 'y'
  end

  def self.valid_date_input(request_text)
    date = ''
    print "#{request_text}: "
    date = gets.chomp.to_s.strip.downcase
    until is_valid_date?(date)
      print 'Please enter a date with correct format: '
      date = gets.chomp.to_s.strip.downcase
    end
    date
  end

  def self.leap_year?(year)
    return true if (year % 400).zero?
    return false if (year % 100).zero?
    return true if (year % 4).zero?
  end

  def self.valid_month_days?(day, month, year)
    answer = false
    if month == 2
      answer = day <= 29 if leap_year?(year)
      answer = day <= 28 unless leap_year?(year)
    elsif [4, 6, 9, 11].include?(month)
      answer = day <= 30
    else
      answer = day <= 31
    end
    answer
  end

  def self.is_valid_date?(date)
    tempdate = date.split(%r{/}, 3)
    date_y = tempdate[0].to_i
    date_m = tempdate[1].to_i
    date_d = tempdate[2].to_i
    year = date_y > 1900
    month = date_m >= 1 && date_m <= 12 if year
    preday = date_d >= 1 if month
    day = valid_month_days?(date_d, date_m, date_y) if preday
    day
  end
end
