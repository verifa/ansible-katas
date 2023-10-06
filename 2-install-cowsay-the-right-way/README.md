# Install *cowsay* the right way

This exercise will introduce you to Ansible builtin modules and how to use them.

*Initialise the exercise by running `./setup.sh` inside of the exercise directory. Wait until you are placed inside the workspace directory in the exercise environment. If you want to reset your environment at any time, you can simply run the setup script again.*

## Introduction to Modules

In the previous exercise we used the `debug` module to see if the install was successful, as the `shell` module does not have this functionality. We also missed an important step: checking if *cowsay* was already installed before executing.

It's important to ensure playbooks avoid performing redundant or potentially harmful tasks, such as installing an already existing tool on a host. We should make sure we get all the necessary information about a task's execution and result. Information such as; did the software install correctly?

---

## Exercise

Let's use a builtin module to perform the same tasks as the previous exercise. We will then examine its features to ensure *cowsay* is not already installed, and checking the installation was successful.

1. Look at the playbook in the workspace directory.

We are now using `ansible.builtin.package` instead of the `shell` module. This is Ansible's generic package manager module for installing and updating packages. There are builtin modules for specific package managers like apt, but using the generic module keeps the playbooks a little friendlier towards multiple operating systems, as Ansible's generic modules will try to use the correct module for the host's OS.

2. Run the playbook (*Remember to replace the HOST_IP like before.*)

``` bash
ansible-playbook -i HOST_IP, playbook.yml --private-key ~/.ssh/id_rsa -u root
```

Note that the reported status from Ansible during our install step was "changed". This is Ansible's way to indicate it has modified something on the host machine without errors (in this case, it installed *cowsay*). If a builtin module were to encounter a problem, it would not return "changed", but an error message instead.

3. Try running the playbook again and check if the output is now "ok" instead of "changed".

Ansible now properly evaluates if the program we want to install already exists on the host and acts accordingly. In this case, an "ok" indicates Ansible considers the desired end state of the task to be "ok" already, thus not requiring any execution.
