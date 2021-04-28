# MovieApp

You can find the following in the MovieApp:
- Movie Home
- Movie Detail
- Search
- Recent Search Cache

https://user-images.githubusercontent.com/16960138/116350315-5ccf5700-a80f-11eb-8629-53829399359e.mov

# Architecture

The app is build using the MVVM Design Pattern. Combine framework is also used for data bindings between the ViewModel & ViewController. The View, 
ViewController, ViewModel are all loosely coupled in order to increase reuse and distribution of responsibility.


View: Resposible for the view related code for the Movie Home screen.

VC: Responsible for data bindings to VM and delegate conformance.

VM: Responsible for making api calls, decoding json, preparing datasource and providing data for VC to show.

Model: Holds the relevant object data.

# Search Cache

The app uses NSKeyedArchiver to store the recently searched movies. NSKeyedArchiver is being used because it's a lightweight solution for the small use case 
of storing user searched movies.
