# Install cowsay the right way

## Intro
We had to create a whole debug task just to see if our install was successful, and we didn't actually check if cowsay was already installed. 

> Short explanation about ansible built in plugins and their benefits compared to the shell plugin.


## exercise
lets use a built in plugin to utilise its features for making sure cowsay isnt already installed, and check that the installation was succesful so that the playbook knows if it should call it a success or not.

* look at the playbook in our workspace directory
* run the playbook:

```
ansible-playbook -i HOST_IP, playbook.yaml --private-key ~/.ssh/id_rsa -u root
```

> short explanation about the different lines in the new playbook.

note that the reported status from ansible during our install step was "changed". Try running it again and see that the output is now "ok" instead of "changed". This is because ansible now properly evaluates if the program we want to install already exists on the host or not, and acts accordingly.