# README

This README will describe how I have constructed the Fonix project.
The task is to create a Rails app that will enable a user to confirm a code
via an SMS sent on their mobile. The project uses Zensend API to send the SMS.

* Ruby version  
The project has been developed with Ruby 2.4.1 and Rails 5.1.6

* Gems used  
	* Zensend 0.0.2
	* Phonelib 0.6.24
	* Bootstrap-sass 3.3.7 and Jquery-rails for styling the pages

* Configuration  
After cloning the repository, you may need to run the following command at the root directory:
	```ruby
	bundle install
	```

* Database set up  
Following are the steps to set up the database(from the root directory):
	```ruby
	bin/rails db:create
	bin/rails db:migrate
	```

* Configuration
You will need to configure a file so the Zensend API will work.
Set the ```api_key:``` attribute in ```config/secrets.yml```
Put your api key so the call to the API will make it. Otherwise, you will have a
NOT_AUTHORIZED exception raised after validating your mobile number.

* Run test suite
To run the tests, run the following command from the root directory:
	```ruby
	bin/rails test
	```
I have mainly focused the test on the controllers as it is the core of the platform.
Please note that I have experienced issues with the API during the development.
I had only £1.00 free credit to test the API. Also, I could not received SMS
from the API even if there were no errors in the API response.
Consequently, I have developed the platform without being sure that everything was working properly
and more specifically for the tests.

* Utilisation
To run the project on your local server, run the following command:
	```ruby
	rails s
	```
This will run a local server serving the project at the following address: ```localhost:3000```
Then you can open a browser and go to ```localhost:3000```.
You will see a basic form, enter a mobile number(preferably yours as you will receive a code to confirm)
Make sure the mobile number respects the international format.
Then you will be redirected to another form to confirm the code you should have received at the number you entered.

* Description of my approach  
After reading the test description, I have first thinking about the data model.
I have quickly highlighted 1 model: MobileNumber that will describe the
application.
Then I have started setting up the app by creating the database, the migration file and the model.
Finally, I have worked on the controller and the views.

* Model description  
I choose to define 1 model that will be describe the behavior of the application.
	* MobileNumber Model  
	The MobileNumber model is responsible for keeping track of numbers entered as
	there is a need to associate a mobile number to the random created. It is also
	helpful for security reasons as I store the ip address of the client who made the request
	to prevent brute force attacks.

* Controller description  
There is 1 main controller that get the data from the model.
	* MobileNumber controller which is taking care of both forms as it is pretty basic forms with one input for each one.

* View description  
Concerning the view, there are 2 main parts:
	* First form to enter the mobile number
	* Second form to confirm the code received

* Prevent form attacks
To prevent the platform from attacks, I have added few things:
	* Check on the validity of the mobile number before making the API call. It has been done with 
	a little plugin called PhoneLib that provides a model validator specific for phone number.
	* Check on the last time this mobile number has been entered. So malicious cannot flood a random
	mobile number with a script.
	* Check on the last time this client IP address has been seen. So malicious user cannot try to overload the
	platform.

* Future improvements
	* Add new rules for checking that the user is not trying to attack the
	* Secure the platform with an authentication feature, for example a simple Devise configuration.
	It will take care of users management so we could eventually ban malicious users.