require 'digest/sha1'

class MainController < ApplicationController

def setmessage
	if(session[:em].nil?)

		session[:em]=[]
		@msgarr=[]
		return
	else
		@msgarr=session[:em]
		session[:em]=[]
	end
end
def index
setmessage()

end


def get_hash(password,has)

strs=password+has
Digest::SHA1.hexdigest strs



end
 def profile
 	id=params[:id]
@us=User.find(id)

@pro=Product.where(:seller_id=>@us.id)

 end
def login
	if (request.method=="GET" )
		#print form
		setmessage()

	elsif (request.method=="POST")
		@err=[]

		#user authenticate
		if(params[:email].empty? or params[:password].empty?)
			@err.push("Fields can't be blank");
		end
		@email=params[:email]
		if(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/.match(@email).size==0)
			@err.push("Email InValid");

		end

		if(@err.size>0)

			session[:em]=@err
			redirect_to action:"login"

		else

			#check in db
			@us=User.where(:email=>params[:email])
			if( @us.size>0)
					@us=@us[0]
			if(@us.pwd==get_hash(params[:password],@us.salt.to_s))
				session[:userdata]=@us
				redirect_to action:"loginsucess"	
				#redirect_to session[:prevurl]	
			else
				@err.push(get_hash(params[:password],@us.salt.to_s))
				@err.push(@us.pwd)

				@err.push((params[:password]+@us.salt.to_s))
				@err.push("Password Incorrect")
				session[:em]=@err
				redirect_to action:"login"
			end
		

			else

				@err.push("Email ID is not in database")
				session[:em]=@err
				redirect_to action:"login"

			end
		end

	end



end
def register



end
def logout

	session[:userdata]=nil
	redirect_to action:"index"

end
def registercomplete
	@msgarr=[]


	if (request.method=="GET")
		session[:email]=session[:userinfo].email
		@email=session[:email]
		@name=session[:userinfo].name
		setmessage()
	elsif (request.method=="POST")

		@err=[]

		n1=params[:fname]
		n2=params[:lname]
		ad=params[:addr]
		em=params[:email]
		ph=params[:mobno]
		pwd=params[:pwd]	
		if(n1.empty? or n2.empty? or ad.empty? or ph.empty? or em.empty? or pwd.empty?)
			@err.push('All Fields cannot be Empty')
		end
		if(ph.length!=10)
			@err.push("Mobile No Invalid");
			end
		if(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/.match(em).size==0)
			@err.push('Email is Invalid')
		end
		if(@err.size>0)
			session[:em]=@err

			redirect_to action:"register"
		elsif (User.where(:email=>params[:email]).size!=0)
				@err.push("Email ID Already exists")
		session[:em]=@err

			redirect_to action:"register"
			
		else
			@user=User.new
			@user.name=session[:userinfo].name
			@user.addr=params[:addr]
			@user.phno=params[:mobno]
			@user.email=session[:email]
			slt=rand(99999).to_s
			@user.salt=slt
			@user.pwd=get_hash(params[:pwd],slt)
			@user.gender=params[:sex]
			@user.verified_by=-1
			@user.usertype="user"
			@user.save
			redirect_to action:"regsucess"
		end
		#insert to db
 

		
	end	
end	
def regsucess


	end
def search 


end
def loginfail


	end


	def loginsucess

	end



end


