# 1. My First Playbook

This exercise will introduce you to Ansible playbooks and how to run them.

*Initialise the exercise by running `./setup.sh` inside of the exercise directory. Wait until you are placed inside the workspace directory in the exercise environment. If you want to reset your environment at any time, you can simply run the setup script again.*

## Where do we start?

In order to perform any action with Ansible we need to write a *playbook*. An Ansible playbook is a YAML file where we can define series of tasks we want Ansible to perform. Defining the desired configuration of our systems in the form of playbooks and tasks helps us ensure consistent setup and configuration across all our environments, every time we want to perform them.

## The playbook

We will use an example playbook to help us understand the basics. In this case, the playbook will install [*cowsay*](https://pypi.org/project/*cowsay*/) on a host.

*A host is Ansible's name for the machine(s) we will be configuring.*

---

## Exercise 1

1. Take a look at the `playbook.yml` in the workspace directory. Don't worry about understanding all of it now.

2. Let's run the playbook. Run the following command from the terminal, replacing `HOST_IP` with the IP that was printed when you ran the `setup.sh` script.

``` bash
ansible-playbook -i HOST_IP, playbook.yml --private-key ~/.ssh/id_rsa -u root
```

![playbook run helper image](/.utils/assets/my-first-playbook_img_1.png)

3. Answer "yes" to the SSH prompt asking if you want to continue connecting.

### What happened?

If everything ran correctly, we should see output similar to the image below:

![playbook run output image](/.utils/assets/my-first-playbook_img_2.png)

Let's revisit the `playbook.yml` and take a look at some of the details to understand what happened.

A playbook can have many *plays*, but for now we only have one, named "install *cowsay*".

The play has the parameters `hosts: all` and `become: yes` which we will ignore for now.

However, what is important is the `tasks` list. The task list contains the tasks Ansible will perform on the target host. Right now, we have one task in the task list, called "Execute the script". This task is a `shell` task, meaning we can use it to write shell commands. In this case it runs an `apt-get update`, and then installs *cowsay*.

## Exercise 2: Make a change

Let's add a new task which checks if the previous installation was successful by running *cowsay* with some dummy text. We will need to store the output of the task to a debug variable and output it to see the result.

1. Add this section to the existing playbook, and re-run the playbook with the same command as last time.

 ```yaml
    - name: Say something
      shell: |
        /usr/games/cowsay hewwo
      register: out
    - debug: var=out.stdout_lines
```
