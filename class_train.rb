=begin
**********************************************************************
Класс Train (Поезд):
    Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, 
    эти данные указываются при создании экземпляра класса
    Может набирать скорость
    Может возвращать текущую скорость
    Может тормозить (сбрасывать скорость до нуля)
    Может возвращать количество вагонов
    Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод просто увеличивает 
    или уменьшает количество вагонов). Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
    Может принимать маршрут следования (объект класса Route). 
    При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
    Может перемещаться между станциями, указанными в маршруте. 
    Перемещение возможно вперед и назад, но только на 1 станцию за раз.
    Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
****************************************************************************************************
=end

#********** Определение Класс Train (Поезд) ***********************************
class Train
  attr_accessor :speed, :curent_station         # возвращать текущую станцию и скорость
  attr_reader :train_number, :train_type, :num_of_cars, :route
  
  attr_reader :route_name                       # маршрут поезда
  attr_reader :condition                        # местонахождение поезда 
  attr_reader :number_car			                  # возвращать количество вагонов
  attr_reader :wagons                           # подвижной состав поезда

  def initialize(number, type, num_of_cars)
    @train_number = number			                # номер поезда
    @train_type = type				                  # тип поезда (грузовой, пассажирский)
    @wagons = []
    @num_of_cars = num_of_cars		              # количество вагонов 
    @speed = 0
    @curent_station = "Харьков"
  end

  # --------------------------------------------- количество вагонов в поезде ----------------
  def number_cars                     			     
    @num_of_cars = wagons.size
    puts "В поезде № #{@train_number} - #{@num_of_cars} вагон"
  end
  
  # --------------------------------------------- назначить поезду маршрут ----------------
  def assign_train_route(assign_route) 	           
    @route = assign_route
    @curent_station = assign_route.station[0]
    @prev_station = nil
    @next_station = assign_route.station[1]
    @condition   = @curent_station
  end
  
  def route_name
    @route.route_name
  end

  # -------------------------------------------- Возвращать положение на маршруте --------
  def train_curent_station 	
     @curent_station
  end

  def train_next_station  
     @next_station
  end

# -------------------------------- перемещаться между станциями, указанными в маршруте ----
  
  # ----------------------------- поезд вперед на 1 станцию по маршруту -------------------
  def train_forward
      speed=60
      @prev_station = @curent_station
      @curent_station = @next_station
      ind = route.station.index(@curent_station).to_i + 1
      @next_station = route.station[ind]
  end

  # --------------------------------------- отправить поезд со станции по маршруту ----------
  def leave_the_station(station)                       		         
    @prev_station = station.name_station  if station.trains.include?(self)
    @curent_station = ""
    i = self.route.station.index(station.name_station ).to_i
    @next_station = self.route.station[i + 1]
    speed=60
  end
  
  # -------------------------------------------- принять поезд на станцию ---------------
  def arrive_at_the_station(station)			                        
    
    speed=0
    @curent_station = station.name_station if station.trains.include?(self)
    @next_station = ""
  end

   # -----------------------------------------  местонахождение поезда ------------------
  def condition
    if speed>0 && curent_station.empty?
      # ----------------------------------- В пути между станциями 
      @condition = "#{@prev_station} - #{@next_station}"
    else
      # ----------------------------------- На станции - #{curent_station}."
      @condition = "#{curent_station}"
    end
  end

  # ------------------------------ ИНФОРМАЦИЯ о поезде -----------------------------------

  def info
    condition
    puts "номер поезда        - #{@train_number}"	      # номер поезда
    puts "Obj поезда          - #{self}"                # номер поезда
    puts "тип поезда          - #{@train_type}"         # тип поезда
    puts "количество вагонов  - #{@num_of_cars}"        # число вагонов в поезде		
    puts "скорость            - #{@speed}"              # скорость поезда
    if @route.nil? == false
      puts "Obj маршрута        - #{@route}"              # Obj маршрута
      puts "название маршрута   - #{@route.route_name}"   # название маршрута
      puts "маршрут             - #{@route.station}"      # список станций по маршруту
    end
    puts "Местонахождение     - #{@condition}"          # местонахождение поезда
    puts "Текущая станция     - #{@curent_station}"     # текущая станция
    puts "Предыдущая станция  - #{@prev_station}"       # предыдущая станция
    puts "Следующая станция   - #{@next_station}"       # следующая станция 
    puts "Состав поезда       - "                       # подвижной состав поезда
    wagons.each_with_index { |wagon,i|  print "#{(i+1).to_s.rjust 5}  #{(wagon.reg_number.ljust 7)}  "\
                                              "#{(wagon.type_wagon.ljust 14)} "\
                                              "#{(wagon.subtype_wagon.ljust 10)} "\
                                              "#{(wagon.location.center 15)}\n" }
  end

  # ------------------------------ прицепить вагон к поезду -----------------------------------

  def add_car(car)                          #car+  - прицепить вагон к поезду
    if speed == 0 
      if (car.type_wagon == @train_type)
        @num_of_cars += 1
        wagons << car
      else
        puts "тип вагона не соответствует типу поезда!"  
      end
    else
      puts "Остановите поезд!"
    end   
  end

  # ------------------------------ отцепить вагон поезда -----------------------------------

  def del_car(car)                          #car-   - отцепить вагон поезда
    if wagons.include?(car)
      @num_of_cars -= 1 if @speed == 0
      wagons.each { |item| wagons.delete(item) if item == car }
    else
      puts "нет такого вагона #{car.reg_number} в поезде!"   
    end
  end
end

class  PassengerTrain < Train 
  
  def initialize(number, type, num_of_cars)
    
    super(number, type="пассажирский", num_of_cars)
    
  end
end

class CargoTrain < Train
  
  def initialize(number, type, num_of_cars)

    super(number, type="грузовой", num_of_cars)
    
  end 
end