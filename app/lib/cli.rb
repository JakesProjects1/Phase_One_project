require_relative "../../config/environment.rb"
Prompt = TTY::Prompt.new
require 'pry'

class Cli


#we want to welcome the user to the evil plan generator
#we want to give them options to search for a villain
#we want to show a list of all villains
#once they've selected a villain, they have the option to view that villain's plans
#They can then see the henchmen associategirt pd with those plans
#they can have the option to create a new henchmen?


def initialize
    @user_input = nil
    @user_plan = nil
    @user_henchman = nil
end


#Evil plan generator artwork

   def render_ascii_art
            puts " "
            puts " "
            puts " "
            puts "
               __        _ _         ___ _                  ___                            _             
              /____   _ (_| |      / _ | | __ _ _ __       / _ \\  ___ _ __   ___ _ __ __ _| |_ ___   _ __ 
             /_\\ \\ \\  / | | |     / /_)| |/ _` |    \\     / /_  \\/ _ | '_ \\ / _ | '__/ _` | __/ _ \\ | '__|
            //__  \\ V / | | |    / ___/| | (_| | || |    / /_ \\ |  __| | | |  __| | | (_| | || (_)  | |   
            \\__/   \\_/  |_|_|    \\/    |_|\\__,_|_||_|    \\____/  \\___|_| |_|\\___|_|  \\__,_|\\__\\___/ |_|   
                                                                                     
            ".red
end




def begin_generator
    puts " "
    puts " "
    puts " "
    puts "                                  Welcome to the Evil Plan Generator".red
    puts " "
    puts "                                  Press 1 to search for a villain".yellow
    puts " "
    puts " "
    puts "                                          -Press q to quit-"
end

#1.
def get_user_data
    render_ascii_art
    begin_generator
    user_data = gets.chomp
   if user_data == '1' 
    choose_villain
    elsif user_data == 'q'
     puts "                               See you later..     ...       ..."
     exit
    else  
        puts "                             Sorry, please enter a valid command.".green
        begin_generator
    end
end

#**********************
#Not directly called in run (referenced in user_data)
def choose_villain
    #puts "Or press 'b' to go back\n.".yellow
    all_bosses = Boss.pluck(:name)
      #List of villains in db
    @user_input = Prompt.select("Please select a villain below:".blue, all_bosses) 
    system "clear"
    boss = Boss.find_by(name: @user_input)
    boss.title
    puts "\n\nYou have chosen #{@user_input}, '#{boss.title}'\n".red
    #Villain name still shows up after selection, will try to find method to clear if possible
    create_look_menu
   
end

#**********************

def create_look_menu
   
    # choices = $user_type.plans.pluck(:job)
    #shows the corresponding plans for that boss
    user_data = Prompt.select("Would you like to create a new plan or look through their list of schemes?".yellow, %w(create look))
       system "clear"
       if user_data == "create"
            boss = Boss.find_by(name: @user_input)
            boss.id
            puts "Type a brief description of your scheme\n\n"
            @user_plan = gets.chomp
            puts "#{boss.name.yellow}'s new scheme, '#{@user_plan.red}' looks good!\n\n"
            new_plan = Plan.find_or_create_by(boss_id: boss.id, job: @user_plan)
            new_plan.save
            view_plan_details
        elsif user_data == "look"
    #pull boss name "string" from user input to then search for their plans in db
        
            boss = Boss.find_by(name: @user_input)
            plans = boss.plans.all
            choices = plans.pluck(:job)
            system "clear"
            @user_plan = Prompt.select("\nWhich plan would you like to choose?\n\n".blue, choices)
            
            view_plan_details
        else
    end
end


def view_plan_details
    boss = Boss.find_by(name: @user_input)
    chosen_plan = Plan.find_by(job: @user_plan)
    
    
    if chosen_plan.henchmen == []
        "There are no henchmen assigned to this scheme"
        choices = %w(yes no)
        
        @user_plan = Prompt.select("Would you like to select a henchman to add?\n\n".blue, choices)
        if @user_plan == "no" 
            puts "Looks like you want to ride solo\n".yellow
            puts "press q to quit\n".red
            user_data = gets.chomp
            system "clear"
                if user_data == 'q'
                    exit  
                end
        elsif @user_plan == "yes"
            all_henchmen = Henchman.pluck(:name)
            @user_henchman = Prompt.select("Please select a henchman below:".blue, all_henchmen)    
            system "clear"
            henchman = Henchman.find_by(name: @user_henchman)
            henchman.specialty
            henchman.save
            puts "\n\nYou have chosen #{@user_henchman}, Specialty:'#{henchman.specialty}'\n".red
            puts "\nGood luck #{@user_input}. We hope all your evil schemes succeed!\n".yellow
            puts "press q to quit\n".red
            puts "press b to go back to main menu\n".red
            user_choice = gets.chomp
                if user_choice == 'q'
                    puts "Goodbye"
                     exit
                elsif user_choice == 'b'
                    system "clear"
                    get_user_data   
                else
            end
        end

        elsif chosen_plan.henchmen != nil
            chosen_henchmen = chosen_plan.henchmen.pluck(:name)[0]
            chosen_specialty = chosen_plan.henchmen.pluck(:specialty)[0]
            @user_plan = Prompt.select("\nHere are the henchmen assigned to this scheme\n\n".blue, chosen_henchmen)
            puts "\n\nYou have chosen #{chosen_henchmen}, Specialty: #{chosen_specialty}\n".red
            puts "Good luck #{@user_input}. We hope all your evil schemes succeed!".yellow
            puts "\npress q to quit\n"
            puts "press b to main menu"
            user_choice = gets.chomp
                if user_choice == 'q'
                    puts "Goodbye"
                    exit
                elsif user_choice == 'b'
                    system "clear"
                    get_user_data   
                else
            end
        end
    end



def choose_plans
    #shows the corresponding plans for that boss
    boss_plans = Boss.boss_object(@user_input)
    #puts "Thank you. Now choose your next evil scheme:"
    puts ""
    plans = boss_plans.plans.pluck(:job)
    @user_input = Prompt.select("Thank you. Now choose your next evil scheme", plans)
    if @user_input
      henchmen
    end
end

def choose_henchman
    puts "Would you like to choose a henchman to add to this plan?"
    puts "yes or no?"
    choose_henchman = gets.chomp
    if choose_henchmen == 'yes'
        henchmen
    elsif choose_henchmen == 'no'
        "Great! Thanks for stopping by!"
        begin_generator
    puts "Would you like to choose a henchman?".yellow
    puts "yes or no?"
#    @user_input = "yes"
    if @user_input == 'yes'
        #Henchman.list_henchmen_names >> if type yes causes an infinite 'y'
    elsif @user_input == 'no'
        hench_plans = Henchman.henchman_plans.plans.pluck(:henchman_id)
        #henchman who comes with job
    end
end
end




end




