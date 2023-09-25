# Install cowsay the right way

This exercise will introduce you to Ansible builtin modules and how to use them.

*Start by initialising the exercise by running ./setup.sh while inside of this exercise folder, and wait until you are put inside the workspace folder of the exercise environment. If you want to reset your environment at any time you can simply run the setup script again.*

## Introduction to Modules

In our previous exercise we utilized the `debug` module to see if our install was successful, as the `shell` module does not have this functionality. We also missed an important step in not checking if cowsay was already installed before executing.

When working in the real world it is important to make sure our playbooks avoid performing tasks that would be harmful or unnessecary to the host, such as running an install on a host where the software already exists. We must also make sure that we are getting all the neccesary information about a task execution so that we can properly test our playbooks, as well as know that they ran successfully in production. Information such as; did the software install correctly?

## Exercise

Let's use a builtin module to perform the same tasks as the previous exercise. We will then examine its features for making sure cowsay is not already installed, and checking that the installation was successful.

1. Look at the playbook in our workspace directory.

We can see that we are now using `ansible.builtin.package` instead of the `shell` module. This is ansibles generic package manager module for installing and updating packages. There are builtin modules for specific package managers like apt, but using the generic module where possible keeps our playbooks a little more flexible to different operating systems, as ansibles generic modules will try to use the correct module for your hosts operating system.

2. Run the playbook: *Remember to replace the HOST_IP like before.*

``` bash
ansible-playbook -i HOST_IP, playbook.yaml --private-key ~/.ssh/id_rsa -u root
```

Note that the reported status from ansible during our install step was "changed". This is ansibles way to indicate that it changed something on the host machine (in this case it installed cowsay) and that there were no errors. If a builtin module were to encounter a problem it would not return "changed", but rather an error message.

3. Try running the playbook again and see that the output is now "ok" instead of "changed".

This is because ansible now properly evaluates if the program we want to install already exists on the host or not, and acts accordingly. In this case an "ok" indicates that ansibles considers the desired end state of the task to already be "ok", thus not requiring any execution, which would then have resulted in a "changed" result.
