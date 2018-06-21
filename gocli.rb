require 'pp'
require 'time'

def menu

    drivers = Array.new
    identity = Hash.new
    jarak = Hash.new
    harga = 300
    
    def distance(x1,y1,x2,y2)
        return Math.sqrt((x1.to_i - x2.to_i) ** 2 + (y1.to_i - y2.to_i) ** 2)
    end
    
    
    for i in 0 ... ARGV.length
        if i == 0
            size = ARGV[0].to_i
        end
        if i == 1
            cust_x = ARGV[1].to_i
        end
        if i == 2
            cust_y = ARGV[2].to_i
        end
     end
    
    unless size
        size = 5
    end
    
    
    maps = Array.new(size) { Array.new(size) }
    
    # Generating Customer's Coordinate
    unless cust_x
        cust_x = rand(size-1)
    end
    unless cust_y
        cust_y = rand(size-1)
    end
    cst_coord =  cust_x.to_s + "," + cust_y.to_s 
    drivers << (cst_coord.to_s)
    
    maps[cust_y][cust_x] = "C"
    
    # Generating 5 Drivers' Coordinate
    for i in 1..5
        driver_x = rand(size-1)
        driver_y = rand(size-1)
        drv_coord =  driver_x.to_s << "," << driver_y.to_s 
        check = drivers.include? drv_coord
        if check
            driver_x = rand(size-1)
            driver_y = rand(size-1)
            drv_coord =  driver_x.to_s << "," << driver_y.to_s 
        end
        drivers << (drv_coord.to_s)
        name = "D" << i.to_s
        identity[:"#{name}"] = drv_coord
    
        maps[driver_y][driver_x] = name
    end

puts "Hello! What do you want to do?"
puts "A. Show Map"
puts "B. Order Go-Ride"
puts "C. View History"
puts "D. Exit"
ans = gets.chomp.to_s

if ans == "A"
    pp maps
    menu()
end
if ans == "B"
    puts "Where do you want to go? (in x,y coordinate)"
    dest_x = gets.chomp.to_i
    unless dest_x
        puts "Please enter your destination X!"
    end
    dest_y = gets.chomp.to_i
    unless dest_y
        puts "Please enter your destination Y!"
    end

    identity.each do |name, coord|
        x1 , y1 = "#{coord}".split(',')
        x2 , y2 = cst_coord.split(',')
        jarak[:"#{name}"] = distance(x1,y1,x2,y2)
    end

    jarak_min = jarak.values.min
    puts "Yay! You've got a driver " << jarak.key(jarak_min).to_s
    puts "Driver will be arrived soon to the pickup location"
    
    x2 , y2 = cst_coord.split(',')
    dest_coord = dest_x.to_s << "," << dest_y.to_s 
    distance_to_destination = distance(dest_x,dest_y,x2,y2)
    price_raw = distance_to_destination * harga
    price = price_raw.ceil

    puts "You will be charged Rp. " << price.to_s << " for your order"
    puts ""
    puts "Please enter Y if you have arrived safely"
    ans2 = gets.chomp.to_s
    if ans2 == "Y" or ans == "y"
        open('history.out', 'a+') { |f|
        f << "\n"
        f << "Time: " << Time.now.to_s << "\n"
        f << "Driver Name: " << jarak.key(jarak_min).to_s << "\n"
        f << "Pickup Location: " << cst_coord.to_s << "\n"
        f << "Destination Location: " << dest_coord.to_s << "\n"
        f << "Price: " << price.to_s << "\n"
        f << "\n"
      }

      puts "Thank you for using GO-CLI"
    end   
    menu()
end

if ans == "C"
    txt = open('history.out')
    puts txt.read
    menu()
end

if ans == "D"
    exit
end


end

menu()