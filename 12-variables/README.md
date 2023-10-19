# Variables

In this Kata we will get to know common ways of injecting variables into your Ansible plays.

## Introduction to Ansible variables

Ansible has many ways for the operator to inject variables into playbooks and plays. There are so many ways that it can cause issues if you don't agree on common conventions and style with your team.

To highlight how complicated things can get; take a quick look at this list of variable precedence. It shows the order of least authoritative variable injection to the greatest (meaning that the last listed variables would override all other variables):

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
22. extra vars (for example, -e "user=my_user") *(always wins precedence)*

*This list is borrowed from the Ansible documentation. Note that there are also some caveats with some of these variables, I suggest checking out the live documentation when deciding which variables to use: <https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#understanding-variable-precedence>*

As an example; you should be mindful of what you set in areas like `role vars`, since it's "high" on the precedence list, and you cannot override those values from outside the role easily.

The [Good Practices for Ansible](https://redhat-cop.github.io/automation-good-practices/#_restrict_your_usage_of_variable_types) recommendation on restricting variable usage is solid, but sometimes the way you automate things might not allow generic "best practices". In that case; define your own and stick to it!

---

## Exercise

This exercise scenario includes 3 hosts, one of them is configured as a loadbalancer and the two remaining hosts are "backends" to which the loadbalancer, well, load balances the traffic to. See the diagram below for visualisation:

![overview diagram](/.utils/assets/vars_overview.svg)

In this exercise we are interested in **variables**, thus we will not dive into the details of the playbook and roles.

### Variables Overview

We will be defining variables on four levels, here they are listed in precedence order from least to greatest:

1. role defaults
2. group vars
3. host vars
4. extra vars

In addition, we will also use some dynamic variables that are gathered from the hosts, called "host facts".

### What are Host Facts?

When you write a playbook you can choose whether or not to gather facts, which is the very first step that ansible will do by default:

```yaml
---
- name: Gather facts so we know details about the backend hosts
  hosts: env_GROUP_backend
  gather_facts: true # Set here. Facts are gathered by default!
```

Facts are gathered by Ansible executing the [setup module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/setup_module.html) on the target hosts. You can also have a play that executes the setup module which would for example allow you to update the facts mid-way through a playbook run (or wherever you would include that module execution). There are some times when that might be useful, but gathering facts can also be slow. In short,  don't gather facts when you don't need to! The below diagram visualises the fact gathering process:

![ansible facts diagram](/.utils/assets/vars_facts.svg)

If you look closely at our `playbook.yml` it actually contains several plays. The facts are first gathered, and are then cached for use in the rest of the plays.

*You can explore the `lb.conf.j2` template to see where the `loadbalancer` role uses the gathered facts:*

```yaml
upstream backend {
{% for server in groups[loadbalancer_backend_group] %}
    server {{ hostvars[server]['ansible_facts']['default_ipv4']['address'] }}:80;
{% endfor %}
}
```

*The value for `loadbalancer_backend_group` is coming from a hardcoded variable defined in the `playbook.yml`:*

```yaml
  - ansible.builtin.include_role:
      name: loadbalancer
    vars:
      loadbalancer_backend_group: env_GROUP_backend #here!
```

*It's definitely not a best practice to provide variables like this, but for the sake of this demo we have done so. A better practice would be to define this variable for the loadbalancer inventory group.*

### Variables for Backends

As seen in the diagram below, the backends each get different values from their `host_vars`. There are no other variables involved except the role defaults.

![backend vars diagram](/.utils/assets/vars_backends.png)

### Variables for LoadBalancer

The loadbalancer variables are quite similar to the backends, but the variables are placed in the `group_vars` instead of `host_vars`:

![loadbalancer vars diagram](/.utils/assets/vars_lb.png)

Next we will examine the actual files. You can always refer back to the diagrams if you feel lost on where we currently are in the structure.

### Examine the variables

1. Take a look at the variable defaults in the load balancer role:

```bash
cat roles/loadbalancer/defaults/main.yml
```

These values are defined in `defaults` instead of in the role `variables`, because it's expected users want to overwrite these values.

2. Next, let's examine the `host_vars` and the defaults for the backend role:

```bash
tail roles/backend/defaults/main.yml host_vars/*
```

As you can see, the variable set in the `host_vars` will overwrite a default of the role. Since this is a very simple scenario the role has only one default value, but in real life roles typically have a huge amount of default variables, making it trivial to change the behaviour of the role without changing the code of the role itself. As is best practice, the name of the variable should reveal its purpose.

Notice also that the variable names are prefixed with the name of the role. This is a best practice to make sure variables don't collide between roles!

3. Next, let's examine the `group_vars` for the loadbalancer:

```bash
tail group_vars/*
```

To keep things simple, most of the logic is already in the role itself, so the only thing configured via variables is the hostname for the "frontend" of the loadbalancer.

*In real life the NGINX would likely need to have a high availability target, so there should be more than one instance of the loadbalancer, all of which are configured to point to the same backends. That's why it makes sense to provide this value in the group level, although right now there's only a single instance of the loadbalancer.*

> **TIP:** If you are wondering about the value of this variable, I suggest checking out the [nip.io website](https://nip.io/) for explanation.

### Run the playbook

4. There's nothing to alter for this exercise, so you can simply run the playbook:

```bash
ansible-playbook -i local.docker.yml playbook.yml
```

5. After running it, browse to: <http://localhost:8080>

You should see the default NGINX page, but if you browse to the frontend hostname we used, then you should see something more interesting: <http://cowsay.127.0.0.1.nip.io:8080>

6. Try refreshing the page few times and you can see the backend changing for requests. See the note below!

> **IMPORTANT:** thanks to browsers being very efficient with connections, you'll need to open dev tools and disable caching in your browser to make the loadbalancer actually connect to different backends (load balance). We cannot know what browser you are running, but as an example in Chrome this is done by pressing F12 to open dev tools and then there's a checkbox to "Disable cache" near the top. If you have difficulties still seeing the effect, then see the example below on verifying this behaviour with `curl`.

7. You can also verify it worked from the workspace container with `curl`:

```bash
curl -H "Host: cowsay.127.0.0.1.nip.io" ansible_katas_host_1:8080
```

Run the command few times and note how the HTML content changes according to the backend, of course in real life you'd probably want to use the same backend color, so that's what we will do next!

### Run the playbook again with extra vars

In order to explore variable precedence, let's use the type of variable that has the highest precedence; `extra vars`. Extra vars can be provided as flags when running the `ansible-playbook` command.

8.Let's try that out by running the below command:

```bash
ansible-playbook -i local.docker.yml --extra-vars "backend_bg_color=green" playbook.yml
```

Now the background should be consistent between the backends! In general it's bad to provide the variable twice with different precedences, so we should probably decide between using `host_vars` or `extra vars` and remove the unnecessary variables.

## Finishing up

After you are finished with this exercise, leave the training environment by either pressing ctrl+d or simply typing `exit` in your terminal.
