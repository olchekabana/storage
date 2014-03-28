module CalcDate
  
   # времени (дней, месяцев, лет) до сдачи проекта
  def time_remain
    now = Date.today
    date = self[:date_stop].to_date
    # f от future
    # p от past
    if now > date
      f = now
      p = date
      exceed = true
    else
      f = date
      p = now
      exceed = false
    end
    mdays = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    mdays[2] = 29 if Date.leap?(p.year)
    if f.day > p.day
      days = f.day - p.day
      sub_month = 0
    else
      days = mdays[p.month] - p.day + f.day
      sub_month = 1
    end
    if f.month > p.month
      months = f.month - p.month - sub_month
      sub_year = 0
    else
      months = 12 - p.month + f.month - sub_month
      sub_year = 1
    end
    years = f.year - p.year - sub_year
    return Hash.[]("exceed"=>exceed, "years"=>years, "months"=>months, "days"=>days)
  end
  
  def start
    self[:date_start].strftime("%d.%m.%Y") || '-'  
  end
  
  def stop
    self[:date_stop].strftime("%d.%m.%Y") || '-'
  end
end