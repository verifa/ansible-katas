# Variables

In this Kata we will get to know common ways of injecting variables into your Ansible plays.

## Introduction to Ansible variables

Ansible has many ways for the operator to inject variables into playbooks and plays. There's so many ways it can cause issues if you don't agree on common conventions and style with your team mates.

Importantly, variables also have a precedence. Here is the order of precedence from least to greatest (the last listed variables override all other variables):

1. command line values (for example, -u my_user, these are not variables)
2. role defaults (defined in role/defaults/main.yml)
3. inventory file or script group vars
4. inventory group_vars/all
5. playbook group_vars/all
6. inventory group_vars/*
7. playbook group_vars/*
8. inventory file or script host vars
9. inventory host_vars/*
10. playbook host_vars/*
11. host facts / cached set_facts
12. play vars
13. play vars_prompt
14. play vars_files
15. role vars (defined in role/vars/main.yml)
16. block vars (only for tasks in block)
17. task vars (only for the task)
18. include_vars
19. set_facts / registered vars
20. role (and include_role) params
21. include params
22. extra vars (for example, -e "user=my_user")(always win precedence)

This list is borrowed from the Ansible documentation. Note that there are also some caveats with some of these variables, I suggest checking out the live documentation when deciding which variables to use: <https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#understanding-variable-precedence>

For example you should be cautious what you set in role vars, since it's rather "high" on the precedence list. You cannot override those values from outside the role anymore easily. In fact, I would recommend that do not place any variables into role vars that you might want to commonly overwrite, the values should be constants and for a good reason (stability of the role etc.).

The [Good Practices for Ansible](https://redhat-cop.github.io/automation-good-practices/#_restrict_your_usage_of_variable_types) recommendation on restricting variable usage is solid, but sometimes the way you automate things might not allow generic "best practices", in that case define your own and stick to it!

---

## Exercise

This exercise scenario includes 3 hosts, one of them is configured as a loadbalancer and the two remaining hosts are "backends" to which the loadbalancer, well, load balances the traffic to. See the diagram below for visualisation:

![overview diagram](/.utils/assets/vars_overview.svg)

In this exercise we are interested in **variables**, thus we will not dive into the details of the playbook and roles.

### Variables Overview

In this exercise we will define variables on four levels, here they are listed in precedence order from least to greatest:

1. role defaults
2. group vars
3. host vars
4. extra vars

In addition, we will also use some dynamic variables that are gathered from the hosts, these are called "host facts". These will have higher precedence than the "host vars", but that's not very important since the variables are accessed under "ansible_facts" in plays. Read more about host facts below.

### What are Host Facts?

When you write a playbook you can choose whether to gather facts which is the very first step that ansible will do by default:

```yaml
---
- name: Gather facts so we know details about the backend hosts
  hosts: env_GROUP_backend
  gather_facts: true # here, facts are gathered by default btw!
```

Facts are gathered by Ansible executing the [setup module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/setup_module.html) on the target hosts. You can also have a play that executes the setup module which would for example allow you to update the facts mid-way through a playbook run (or where ever you would include that module execution). There are some times when that might be useful, but sometimes gathering facts can also be slow and you want to avoid it. Don't gather facts when you don't need to! The below diagram visualises the fact gathering process:

![ansible facts diagram](/.utils/assets/vars_facts.svg)

In our scenario, these facts are first gathered in a separate play, and they are then cached for the remaining of the playbook run. This sort makes the playbook more of a "playbook of playbooks", but technically they are just plays targeting different hosts and what matters is that this is all done with a single `ansible-playbook` command!

You can explore the `lb.conf.j2` template to see where the `loadbalancer` role uses the gathered facts:

```yaml
upstream backend {
{% for server in groups[loadbalancer_backend_group] %}
    server {{ hostvars[server]['ansible_facts']['default_ipv4']['address'] }}:80;
{% endfor %}
}
```

You might not notice it first but inside the `{% %}` block we are using an variable without the usual double curly braces around them, this is possible in Jinja templates. The value for `loadbalancer_backend_group` is coming from a hardcoded variable defined in the `playbook.yml`:

```yaml
  - ansible.builtin.include_role:
      name: loadbalancer
    vars:
      loadbalancer_backend_group: env_GROUP_backend #here!
```

It's definitely not a best practice to provide variables like this, but for the sake of this demo we've done it. Better way would be to define this variable for the loadbalancer inventory group.

### Variables for Backends

As seen in the diagram below, the backends each get different values from their `host_vars`, other than that there's no other variables involved expect the role defaults:

![backend vars diagram](/.utils/assets/vars_backends.png)


### Variables for LoadBalancer

The loadbalancer variables are quite similar to the backends, but the variables are placed in the `group_vars` instead of `host_vars`:

![loadbalancer vars diagram](/.utils/assets/vars_lb.png)

Next we will examine the files, just refer to the diagrams to understand the structure.

### Examine the variables

See the defaults in the role:

```bash
cat roles/loadbalancer/defaults/main.yml
```

These values are defined in `defaults` instead of in the role `variables`, because it's expected users want to overwrite these values.

Next, let's examine the `host_vars` and the defaults for the backend role:

```bash
tail roles/backend/defaults/main.yml host_vars/*
```

As you can see, the variable set in the `host_vars` will overwrite a default of the role. Since this is a very simple scenario the role has only one default value, but in real life roles typically have a huge amount of default variables so that it's trivial to change the behaviour of the role without changing the code of the role itself. As is the best practice, the name of the variable should reveal the purpose of the variable. If you wonder what that purpose is at this point, you will likely realise it once the playbook is run and you examine the results. I apologise for the unclear name if it's only clear at that point, but as we know, naming is one of the two hard problems in Computer Science.

Notice also that the variable names are prefixed with the name of the role, this is a best practice to make sure variables don't collide between roles. Always do this!

Next, let's examine the `group_vars` for the loadbalancer:

```bash
tail group_vars/*
```

To keep things simple, most of the logic is already in the role itself, so the only thing configured via variables is the hostname for the "frontend" of the loadbalancer. In real life the NGINX would likely need to have a high availability target, so there should be more than one instance of the loadbalancer, all of which are configured to point to the same backends. That's why it makes sense to provide this value in the group level, although right now there's only a single instance of the loadbalancer.

> **TIP:** You might wonder about the value of this variable, if you do I suggest checking out the [nip.io website](https://nip.io/) for explanation.

### Run the playbook

There's nothing to alter for this exercise, so you can simply run the playbook:

```bash
ansible-playbook -i local.docker.yml playbook.yml
```

After running it browse to: <http://localhost:8080>

You should see the default NGINX page for the distro, but if you browse to the frontend hostname we used, then you should see something more interesting: <http://cowsay.127.0.0.1.nip.io:8080>

Try refreshing the page few times and you can see the backend changing for requests. See the note below!

> **IMPORTANT:** thanks to browsers being very efficient with connections, you'll need to open dev tools and disable caching in your browser to make the loadbalancer actually connect to different backends (load balance). We cannot know what browser you are running, but as an example in Chrome this is done by pressing F12 to open dev tools and then there's a checkbox to "Disable cache" near the top. If you have difficulties still seeing the effect, then see the example below on verifying this behaviour with `curl`.

Can also verify it worked from the workspace container with `curl`:

```bash
curl -H "Host: cowsay.127.0.0.1.nip.io" ansible_katas_host_1:8080
```

Run the command few times and note how the HTML content changes according to the backend, of course in real life you'd probably want to use the same backend color, so that's what we will do next!

### Run the playbook again with extra vars

In order to explore variable precedence, let's use the type of variable that has the highest precedence; `extra vars`. Extra vars can be provided as flags when running the `ansible-playbook` command. Let's try that out by running the below command:

```bash
ansible-playbook -i local.docker.yml --extra-vars "backend_bg_color=green" playbook.yml
```

Now the background should be consistent between the backends! In general it's bad to provide the variable twice with different precedences, so we should probably decide between using `host_vars` or `extra vars` and remove the unnecessary variables.
