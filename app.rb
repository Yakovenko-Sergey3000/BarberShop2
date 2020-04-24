require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
    db = SQLite3::Database.new 'barbershop.db'
    db.results_as_hash = true
    return db
   end  

configure do 

    db = get_db
    db.execute 'CREATE TABLE IF NOT EXISTS
     "Users"
      (
      Id integer PRIMARY KEY AUTOINCREMENT,
      name varchar,
      phone varchar,
      date_stamp varchar,
      name_master varchar,
      color varchar
      )'

 end  

get '/' do 
    erb "Hello!"
end 

get '/about' do 
	
 	erb :about
end 

get '/visit' do 

 	erb :visit
end 

get '/contacts' do 
 	erb :contacts
end

post "/visit" do
	@user_name = params[:username]
	@phone = params[:phone]
	@data_stamp = params[:datetime]
	@name_master = params[:name]
	@color = params[:color]
    
    	hh = {:username =>"Введите имя!",
    		  :phone => "Введите номер!",
    		  :datetime => "Введите дату и время!"}	  
    		

    	@error = hh.select {|key,_| params[key] == ""}.values.join()

    	if @error != ""
    		return erb :visit
    	end	

      db = get_db
      db.execute 'insert into 
      Users
      (
          name,
          phone,
          date_stamp,
          name_master,
          color
       ) 
       values (?,?,?,?,?)', [@user_name,@phone,@data_stamp,@name_master,@color] 

   erb "Hello #{@user_name}"

   end


post '/contacts' do 
 
require 'pony'
Pony.mail({
  
  :from => "sergeyyakovenko15@gmail.com",
  :body => params[:body],
  :to => "mvolynskih@gmail.com",
  :subject => " Sergey Yakovenko",
  :via => :smtp,
  :via_options => { 
    :address              => 'smtp.gmail.com', 
    :port                 => '587', 
    :enable_starttls_auto => true, 
    :user_name            => "sergeyyakovenko15@gmail.com", 
    :password             => "][poiuytrewq", 
    :authentication       => :plain,
    :domain               => 'localhost.localdomain'
}
})

erb "Сообщение отправленно!"
end

get '/showusers' do
#    db = get_db
#     db.execute 'select * from Users' do |row|
#        return erb row.to_s
# end 
  erb :showusers
     
   
end



get '/admin' do 
		erb :login_form
end

# post '/admin' do 
#     @login = params[:login]
#     @password = params[:password]

#  		if @login == "admin"&& @password == "admin"
 			 
#  			erb :welcome

#  		else 
#  			@massege = "Sorry, Error Password!!!"
#  			erb :login_form
#  		end 		


# end
