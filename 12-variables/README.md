# Variables

In this Kata we will get to know common ways of injecting variables into your Ansible plays.

## Introduction to Ansible variables

Ansible has many ways for the operator to inject variables into playbooks and plays. There's so many ways it can cause issues if you don't agree on common conventions and style with your team mates.

Variables also have a precedence. Here's the precedence list as of writing this:

> Here is the order of precedence from least to greatest (the last listed variables override all other variables):

1. command line values (for example, -u my_user, these are not variables)
1. role defaults (defined in role/defaults/main.yml)
1. inventory file or script group vars
1. inventory group_vars/all
1. playbook group_vars/all
1. inventory group_vars/*
1. playbook group_vars/*
1. inventory file or script host vars
1. inventory host_vars/*
1. playbook host_vars/*
1. host facts / cached set_facts
1. play vars
1. play vars_prompt
1. play vars_files
1. role vars (defined in role/vars/main.yml)
1. block vars (only for tasks in block)
1. task vars (only for the task)
1. include_vars
1. set_facts / registered vars
1. role (and include_role) params
1. include params
1. extra vars (for example, -e "user=my_user")(always win precedence)

There are also some caveats with regards these variables, I suggest checking out the live documentation when deciding which variables to use: <https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#understanding-variable-precedence>

For example you should be cautious what you set in role vars, since it's rather "high" on the precedence list. You cannot override those values from outside the role anymore easily. In fact, I would recommend that do not place any variables into role vars that you might want to commonly overwrite, the values should be constants and for a good reason (stability of the role etc.).

The [Good Practices for Ansible](https://redhat-cop.github.io/automation-good-practices/#_restrict_your_usage_of_variable_types) recommendation on restricting variable usage is solid, but sometimes the way you automate things might not allow generic "best practices", in that case define your own and stick to it!

## Exercise

**TODO: explain the scenario using a diagram, can be just ascii**

In this exercise we will define variables on four levels, here they are listed in precedence order from least to greatest:

1. role defaults
2. group vars
3. host vars
4. extra vars

In addition, we will also use some dynamic variables that are gathered from the hosts, these are called "host facts". These will have higher precedence than the "host vars", but that's not very important since the variables are accessed under "ansible_facts" in plays.


### Examine the variables

See the defaults in the role:

```bash
cat roles/loadbalancer/defaults/main.yml
```

These values are defined in `defaults` instead of in the role `variables`, because it's expected users want to overwrite these values.

Next, let's examine the `group_vars` and `host_vars`:

```bash
tail -1000 group_vars/*
tail -1000 host_vars/*
```

There's not a lot going on here, we will set a hostname for the frontend and the backend hosts both have different colors for the background of the website they are running.


### Run the playbook

```bash
ansible-playbook -i local.docker.yml playbook.yml
```

**TODO:**, rm this and bake it into the description that starts the exercise:

nginx proxy that forwards traffic to 2 backends, backends also run nginx but just regular webpage with the IP and some other info of the host configured

1. role defaults for most shite
2. inventory_vars for the hostname in nginx proxy (nip.io stuff, maps to 127.0.0.1 but nginx forwards the traffic based on the Host header)
3. host vars for background color of the website, different between backends
4. extra vars as extra demo to override the background to different color, then it's consistent between backends


After running it browse to: <http://localhost:8080>

You should see the default NGINX page for the distro, but if you browse to the frontend hostname we used, then you should see something more interesting: <http://cowsay.127.0.0.1.nip.io:8080>

Try refreshing the page few times and you can see the backend changing for requests.

Can also verify it worked from the workspace container:

```bash
curl -H "Host: cowsay.127.0.0.1.nip.io" ansible_katas_host_1:8080
```

### Run the playbook again with extra vars


```bash
ansible-playbook -i local.docker.yml --extra-vars "backend_bg_color=green" playbook.yml
```

Now the background should be consistent!

**TODO: move this to right places with description**

![overview diagram](/.utils/assets/vars_overview.svg)

![backend vars diagram](/.utils/assets/vars_backends.png)

![loadbalancer vars diagram](/.utils/assets/vars_lb.png)

![ansible facts diagram](/.utils/assets/vars_facts.svg)