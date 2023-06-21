# Run a simple playbook

> Breakdown about what a playbook is.
> 
## The playbook
Playbook installs `cowsay` on the host(s).

## Run it
1. Take a look at the playbook.yaml in the workspace directory.
2. run the playbook by copy pasting the following command and switch out HOST_IP to the ip that was output in your command line when you ran the setup.sh.
```
ansible-playbook -i HOST_IP, playbook.yaml --private-key ~/.ssh/id_rsa -u root
```
### What happened

>break down of how a playbook works here line by line

We told it to install the application, but how do we know it actually did?

It would be nice to see that it was successful, and perhaps test the application ?

## Make a change
lets add a new task that checks that the previous installation was successful by running cowsay with some example text. We will need to store the output of the task to a debug variable and output it to see the result.

3. copy paste this section into our existing playbook where you think it should go, and try running it again with the same command as last time.

 ```yaml
    - name: Say something
      shell: |
        /usr/games/cowsay hewwo
      register: out
    - debug: var=out.stdout_lines 
```

>short explanation of the shell and debug plugins.
