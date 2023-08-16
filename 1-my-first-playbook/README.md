# 1. My First Playbook

This exercise will introduce you to Ansible playbooks and how to run them.

## Where do we start?
In order to perform any action with Ansible we need to write a *playbook*. An Ansible Playbook is a YAML file where we can define series of tasks that we want Ansible to perform. Defining our desired configuration of our systems in the form of playbooks and tasks helps us ensure consistent setup and configuration across all our different environments, every time we want to perform them.

## The playbook
We will use an example playbook to help us understand the basics. In this case, our playbook will install [cowsay](https://pypi.org/project/cowsay/)
on a host[^1].

[^1]: A host is Ansibles name for the machine(s) we will be configuring.

## Exercise 1

*Start by initialising the exercise by running ./setup.sh while inside of this exercise folder, and wait until you are put inside the workspace folder of the exercise environment. If you want to reset your environment at any time you can simply run the setup script again.*

1. Take a look at the `playbook.yaml` in the workspace directory.

2. Let's run the playbook. Copy paste the following command into your terminal after replacing HOST_IP with the ip that was generated when you ran the `setup.sh`.

```
ansible-playbook -i HOST_IP, playbook.yaml --private-key ~/.ssh/id_rsa -u root
```

![playbook run helper image](/utils/assets/my-first-playbook_img_1.png)

3. Answer "yes" to the SSH prompt asking if you want to continue connecting.

### What happened?

If everything ran correctly, we should see some output like the example image below:

![playbook run output image](/utils/assets/my-first-playbook_img_2.png)

Let's open up the `playbook.yaml` again and take a look at some of the details to understand what happened.

For now we only have one *play*, named "install cowsay". The play has the parameters `hosts: all` and  `become: yes` which can be ignored for now.

However, what is important for now is the `tasks` list. Right now we have one task in the task list, called "Execute the script". This task is a `shell` task, meaning we can use it to write shell commands that ansible will execute. Our task runs an apt-get update, and then installs cowsay.

## Exercise 2: Make a change
Let's add a new task that checks that the previous installation was successful by running cowsay with some example text. We will need to store the output of the task to a debug variable and output it to see the result.

1. Copy paste this section into our existing playbook where you think it should go, and try re-running the playbook with the same command as last time.

 ```yaml
    - name: Say something
      shell: |
        /usr/games/cowsay hewwo
      register: out
    - debug: var=out.stdout_lines
```
