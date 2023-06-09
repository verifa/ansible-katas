Explanation of collections, why and when to use them. link to website blabala. 

exercise:
have them use a basic collection. make sure its something they can easily check if it was successful. have them write something to make it worked?
 we need to choose a collection, try using it and see the output and see what we need.

'ansible-galaxy collection install my_namespace.my_collection'

to list installed collections, run ansible-galaxy collection list. 

# when using in a role.
# myrole/meta/main.yml
collections:
  - my_namespace.first_collection
  - my_namespace.second_collection
  - other_namespace.other_collection


You can set up a requirements.yml file to install multiple collections in one command. 


todo: what collection should we use?