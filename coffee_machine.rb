# Создаём объект класс
class CoffeMachine
	def make_foffee
		puts "Готовим воду и зёрна"
		puts "Варим и наливаем воду"
	end
end

# Создаём экземпляр класса
saeco = CoffeMachine.new
 
# Вызываем у экземпляра класса метод make_coffee
saeco.make_foffee

# ---

# Инженеры «Гурмана» проанализировали код «Кофемашины» и заметили, что метод
# make_coffee — хороший кандидат для расчленения, что и было сделано:
class CoffeMachine
	def make_coffee
		# Набираем воду (200мл)
		get_wather(200)

		# Набираем зёрна(50г)
		get_beans(50)

		# Кипятим воду
		boil_wather

		# Наливаем кофе в чашку
		pour_coffee
	end
    
    # ---

	def get_wather(mls)
		puts "Набираем в ёмкость #{mls} мл воды."
	end

	def get_beans(grams)
		puts "Отбираем из контейнера #{grams} грамм зёрен."
	end

	# ---

	def boil_wather
		puts "Кипятим воду."
	end

	# ---

	def pour_coffee
		puts "Наливаем коффе в чашку."
	end

	# ---
    
    # Чтобы скрыть часть методов объекта от внешнего мира, их делают
    # частными (private) или защищенными (protected). 
    # Отличие между ними тонкое, как лезвие японского меча.
    # такие методы получится применить только внутри других методов этого
    # же объекта (как boil_water вызывается внутри make_coffee) или его
    # родственника .
	protected 

	def get_wather(mls)
		puts "Набираем в ёмкость #{mls} мл воды."
	end
    
    # ---
end

# Создаём экземпляр класса saeco
saeco_1 = CoffeMachine.new

# Вызываем у экземпляра класса метод boil_wahter
# saeco_1.get_wather
# Получаем вот такую ошибку
# => protected method `get_wather' called for 
#<CoffeMachine:0x00005653510d1600> (NoMethodError)

# Вызывываем у экземпляра класса метод make_coffee
puts
saeco_1.make_coffee

# Чистильщик устроен очень просто: он берет объект-кофемашину и запускает
# у нее подзадачи набора, кипячения и слива воды (фактически, он будет пытаться
# налить кофе, но сливаться-то будет только кипяток), таким образом, ёмкость очищается от кофейных смол.
# Чистильщиков будет двое: один будет создан с нуля, а другой — наследован от «Кофемашины»
# поэтому у него будут те же методы, что и у самой кофемашины.
class Cleaner
	def clean(machine)
		machine.get_wather(200)
		machine.boil_wather
		machine.pour_coffee
	end
end

class MachineCleaner < CoffeMachine
	def clean(machine)
		machine.get_wather(200)
		machine.boil_wather
		machine.pour_coffee
	end
end

# Создаём экземпляр класса cleaner
cleaner = Cleaner.new

# Создаём ещё один экземпляр класса machine_cleaner
machine_cleaner = MachineCleaner.new

# Вызываем у экземпляра класс cleaner метод clean и в скобках передаём 
# эзкемпляр класса к которому будет приметод метод clean, в нашем случае (saeco_1)
# cleaner.clean(saeco_1) 
# в результате мы получим снова ошибку из-за приватного метода
# => `clean': protected method `get_wather' called for 
#<CoffeMachine:0x00005578ee792b30> (NoMethodError)

# делаем ту же операцию со вторым экземпляром класса machine_cleaner
puts 
machine_cleaner.clean(saeco_1)

# ---

class CappuccinoMachine < CoffeMachine
	def create_foam
		prapaire_milk
		push_foam
	end

	private

	def prapaire_milk
		puts "Отбираем и кипятим молоко"
	end

	def push_foam
		puts "Выпускаем молочную пенку в чашку"
	end
end

# Создаём экземпляр класса bosch
bosch = CappuccinoMachine.new

# Вызываем родительский метод make_coffee
puts
bosch.make_coffee
bosch.create_foam

# ---

# Новое задание, нужно разработать капсульную кофемашину
class CapsuleMachine < CoffeMachine
	def make_coffee
		get_wather(200)
		prepare_capsule
		boil_wather
		pour_coffee
	end

	private

	def prepare_capsule
		puts "Вскрываем капсулу и высыпаем коффе а ёмкость."
	end
end


# Создаём экземпляр класса delonghi
delonghi = CapsuleMachine.new

# Вызываем родительский метод make_coffee в котором мы дописали новый метод prapare_capsule
puts
delonghi.make_coffee

# ---

# Несколько слов о super
class OldMan
	def say_wisdom
		puts "Народу много, а людей немного."
	end
end

class Man < OldMan
	def say_wisdom
		super
		puts "Так мой предок говаривал"
	end
end

man = Man.new

puts 
man.say_wisdom

# ---

# Маркетологи «Гурмана», вдохновленные успешными продажами капсульной модели, требуют 
# срочно начать выпуск делюкс-версии: капсульной кофемашины с капучинатором!
# И тут на помощь приходят модули Ruby. Модуль представляет собой именованную группу. 
# Если в ней разместить методы, их можно будет «подмешать» к методам любого класса.
# Методы капучинатора — очень хорошие кандидаты для вынесения в модуль, потому что 
# они должны присутствовать сразу в двух моделях (классах) и отсутствовать в двух других.
module Cappuccinator
	def create_foam
		prepare_milk
		push_foam
	end

	private

	def prepare_milk
		puts "Отбираем и кипятим молоко"
	end

	def push_foam
		puts "Выпускаем молочную пенку в чашку"
	end
end

# ---

# Теперь надо включить этот модуль в «Капучинщик», удалив его старые методы:
class CappuccinoMachine < CoffeMachine
	include Cappuccinator
end

# Модель капсульной кофемашины с капучинатором получается так же просто:
class CapsuleCappuccino < CapsuleMachine
	include Cappuccinator
end

# Создаём экземпляр класса CapsuleCappuccino gaggia
puts
gaggia = CapsuleCappuccino.new

# Вызываем родительский метод с корректировками make_coffee и следом
# вызываем метод перезаписанный с помощью модуля creat_foam
gaggia.make_coffee
gaggia.create_foam

# ---

# Раз капсульную машину с капучинатором отнесли к топовой модели, 
# можно запрограммировать в ней основы латте-арта:
class CapsuleCappuccino < CapsuleMachine
  include Cappuccinator

  def push_foam
  	puts "Красивыми узороми выкладываем пенку в чашку."
  end

  private :push_foam
end

puts
gaggia.make_coffee
gaggia.create_foam

# ---

# Но инженеры уже задницей чувствуют, что завтра может поступить
# команда включить латте-арт еще в какую-то модель! Наверное, лучше 
# вынести его в отдельный модуль:
module LatteArt
	private

	def push_foam
		puts "Красивыми узороми выкладываем пенку в чашку."
	end
end

# Тогда CapsuleCappuccino, очевидно, можно переписать:

class CapsuleCappuccino < CapsuleMachine
	include Cappuccinator
	include LatteArt
end

gaggia = CapsuleCappuccino.new

puts
puts "Модуль в деле"
gaggia.create_foam

#  ---

# Геттеры и сеттеры
# Например, хорошо бы позволить устанавливать количество кофе (в чашках)
# которое должна сварить кофемашина, и заодно проверять, какое оно сейчас. 
# Для это создается пара обычных методов: геттер и сеттер.
class CoffeeMachine
	# геттер
	def cups_count
		# Отдаём наружу (показываем) значение переменной
		@cups_count
	end

	# сеттер
    def cups_count=(count)
    	# Присваиваем значение, пришедшее из вне
      @cups_count = count 	
    end
end

    
# Кстати, в Ruby есть очень удобный метод класса — attr_accessor, который создаст
# эту пару методов на лету.
class CoffeeMachine
	attr_accessor :cups_count
end

# Имя сеттера вовсе не обязательно заканчивать символом =, 
# можно использовать, например:
class CoffeeMachine2
	# неудобный сеттер
	def set_cups_count(count)
		@cups_count = count
	end
end

# Но тогда присваивать значение придётся так
puts
puts "Геттеры в деле"
machine = CoffeeMachine2.new
machine.set_cups_count(1)

# А вот если сеттер был задан со знаком равенства в конце имени, Ruby добавляет к 
# присваиванию ложку синтаксического сахара:
puts
puts "Сеттеры в деле"
machine = CoffeeMachine.new
# То же, что и machine.cups_count=(1)
machine.cups_count = 1

# Этот синтаксический сахар, правда, может привести к недоразумениям, потому что 
# по умолчанию Ruby воспринимает присваивание как команду инициализировать
# локальную переменную.
class CoffeeMachine
	attr_accessor :cups_count

	def set_default_cups_count
		cups_count = 1
	end
end

puts
nespresso = CoffeeMachine.new
nespresso.set_default_cups_count
nespresso.cups_count

# ---

# По этой причине у всех сеттеров обязательно нужно указывать объект вызова, даже если 
# это self (если сеттер является частным, где self указывать запрещено, Ruby делает поблажку).
class CoffeeMachine
	attr_accessor :cups_count

	def set_default_cups_count
		self.cups_count = 1
	end
end

puts
bosch = CoffeeMachine.new
bosch.set_default_cups_count
bosch.cups_count

# ---

# Создание объекта
# initialize. Ruby автоматически делает этот метод частным и вызывает одновременно с
# методом new класса.
class CoffeeMachine
	attr_accessor :cups_count

	def initialize(count = 1)
		@cups_count = count
	end
end
puts
puts "Работает метод initialize"
bosch = CoffeeMachine.new(2)
bosch.cups_count

# ---

# Синглтон методы
# Пока мы разбирались с геттеро-сеттерами, руководство «Гурмана» поставило перед 
# инженерами очередную задачу: каждый раз, когда с конвейера сходит тысячная
# кофемашина, должна раздаваться радостная мелодия, вдохновляющая работников на
# трудовые подвиги.
class CoffeMachine
	def self.new
		# ...
	end
end

# Наконец, в Ruby есть возможность открыть объявление синглтон класса и 
# записывать там его методы:
class << CoffeeMachine
	class << self
		def new
			...
		end
	end
end

# поскольку сам метод должен возвращать созданный объект, его придется временно 
# сохранять в локальной переменной:
class CoffeeMachine
	# Создаём объект с помощью метода new
	def self.new
		# как -то уведомляем счётчик
		machine = super

		# Возвращаем созданный объект (неявный return)
	end
end

# ---

# Когда должен происходить проигрыш мелодии? Когда это количество кратно тысяче. 
# Значит, нужен хитрый сеттер, который будет не только присваивать переменной 
# значение, но и делать проверку на кратность.
class HappyCounter
	# Удобный способ создать геттер
	attr_reader :count

	# Сеттер
	def count=(value)
		@count = value
		play_melody if premium_count?
	end

	def initialize
		@count = 0
	end

	def premium_count?
		# Проверяем остаток от деления 
		@count % 1000 == 0
	end

	private

	def play_melody
		puts "Та-дааам!!!"
	end
end

# Но ведь можно изолировать весь 
# Счетчик, сделав его собственностью объекта CoffeeMachine! Тогда взаимодействовать 
# со Счетчиком сможет только сам конвейер. Для этого в CoffeeMachine понадобится 
# переменная для хранения объекта и сеттер (а вот геттера не будет, тогда к созданному 
# Счетчику извне никто не доберется).
# Сеттер можно задать так:
class CoffeeMachine
	def self.counter=(object)
		@counter = object
	end
    
    # ...
end

# А можно воспользоваться методом класса attr_writer, но для этого понадобится 
# «войти» в синглтон класс:
class CoffeeMachine
	class << self
		attr_writer :counter
	end

	# ...
end

# Теперь становится понятно, как уведомить Счетчик о создании нового объекта:
class CoffeeMachine
	def self.new
		machine = super
		# То же, что и @counter.count = @counter.count + 1
		@counter.count += 1
		machine
	end

	# ...
end

puts
puts "Всё вместе"
CoffeeMachine.counter = HappyCounter.new
999.times do
	CoffeeMachine.new
end

premium_machine = CoffeeMachine.new