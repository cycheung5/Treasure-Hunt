class Room
    attr_reader :hazards, :neighbors, :number
    attr_writer :hazards, :neighbors
    def initialize(number)
        @number = number
        @hazards = []
        @neighbors = []
    end

    def empty?
        return @hazards.empty?
    end

    def add(problem)
        return @hazards.append(problem)
    end
    
    def has? (problem)
        return @hazards.include?(problem)
    end

    def remove(problem)
        return @hazards.delete(problem)
    end

    def connect(new_room)
        @neighbors.append(new_room)
        new_room.neighbors.append(self)
    end

    def neighbor(findnumber)
        return @neighbors.find {|room| room.number == findnumber}
    end
    
    def exits
        roomarray = []
        @neighbors.each {|room| roomarray.append(room.number)}
        return roomarray
    end

    def random_neighbor
        return @neighbors.sample
    end

    def safe?
        # itself and neighbors dont have hazards
        return (@hazards.empty?) && (@neighbors.all? {|haz| haz.empty?})
    end

end

class Cave

    def self.dodecahedron
        cave_rooms = Array(1..20).map {|room| room = Room.new(room)}
        
        # 1
        cave_rooms[0].connect(cave_rooms[1])
        cave_rooms[0].connect(cave_rooms[4])
        cave_rooms[0].connect(cave_rooms[7])
        #2
        cave_rooms[1].connect(cave_rooms[2])
        cave_rooms[1].connect(cave_rooms[9])
        # 3
        cave_rooms[2].connect(cave_rooms[3])
        cave_rooms[2].connect(cave_rooms[11])
        #4
        cave_rooms[3].connect(cave_rooms[4])
        cave_rooms[3].connect(cave_rooms[13])
        #5
        cave_rooms[4].connect(cave_rooms[5])
        #6
        cave_rooms[5].connect(cave_rooms[6])
        cave_rooms[5].connect(cave_rooms[14])
        #7
        cave_rooms[6].connect(cave_rooms[7])
        cave_rooms[6].connect(cave_rooms[16])
        #8
        cave_rooms[7].connect(cave_rooms[10])
        #9
        cave_rooms[8].connect(cave_rooms[9])
        cave_rooms[8].connect(cave_rooms[11])
        cave_rooms[8].connect(cave_rooms[18])
        #10
        cave_rooms[9].connect(cave_rooms[10])
        #11
        cave_rooms[10].connect(cave_rooms[19])
        #12
        cave_rooms[11].connect(cave_rooms[12])
        #13
        cave_rooms[12].connect(cave_rooms[13])
        cave_rooms[12].connect(cave_rooms[17])
        #14
        cave_rooms[13].connect(cave_rooms[14])
        #15
        cave_rooms[14].connect(cave_rooms[15])
        #16
        cave_rooms[15].connect(cave_rooms[16])
        cave_rooms[15].connect(cave_rooms[17])
        #17
        cave_rooms[16].connect(cave_rooms[19])
        #18
        cave_rooms[17].connect(cave_rooms[18])
        #19
        cave_rooms[18].connect(cave_rooms[19])


        return cave = Cave.new(cave_rooms)

        
    
    end 

    def initialize(cave_rooms)
        @cave_rooms = cave_rooms
    end

    def room(room_number)
        return @cave_rooms[room_number - 1]
    end

    def random_room
        return @cave_rooms.sample      
    end

    def move(hazard, original_place, new_place)
        original_place.remove(hazard)
        new_place.add(hazard)
    end

    def add_hazard(hazard, number)
        number.times do
            possibleroom = random_room
            redo unless !possibleroom.has?(hazard)
            possibleroom.add(hazard)
        end

    end

    def room_with(hazard)
        return @cave_rooms.find{|room| room.has?(hazard)}
    
    end

    def entrance
        return @cave_rooms.find{|room| room.safe?}
    end

end

class Player

    attr_reader :room
    attr_writer :room
    def initialize()
        @sensemap = Hash.new()
        @encountermap = Hash.new()
        @actionmap = Hash.new()
        @room 
    end


    def sense(hazard, &codeblock)
        return @sensemap[hazard] = codeblock
    end

    def encounter(hazard, &codeblock)
        return @encountermap[hazard] = codeblock
    end

    def action(doing, &codeblock)
        return @actionmap[doing] = codeblock
    end

    def enter(destination)
        @room = destination
        if !@room.empty?
            haz = @room.hazards[0]
            @encountermap[haz].call
        end
    end

    def explore_room
        neighbors = @room.neighbors
        neighbors.each do |item|
            if !item.empty?
                haz = item.hazards[0]
                @sensemap[haz].call
            end
        end
    end

    def act(action, place)
        return @actionmap[action].call(place)
    end



end

