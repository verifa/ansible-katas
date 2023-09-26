# Roles

This exercise will introduce you to roles and their applications.

*Start by initialising the exercise by running ./setup.sh while inside of this exercise folder, and wait until you are put inside the workspace folder of the exercise environment. If you want to reset your environment at any time you can simply run the setup script again.*

## What are Roles?

As our playbooks grow both in size and in numbers, we might feel a need to separate certain tasks into logical reusable groupings, which Ansible calls "Roles". I suppose the name alludes to the way an actor would take on a role in a play, as it does not have anything to do with permissions. Our playbook will then consist of running a selection of roles, and the individual roles will contain the actual task implementations. This is great if you have a large number of playbooks reusing similar code, as now when you have to update your playbooks, you only need to perform the change in the role, not every playbook implementing it. When we group together tasks into a role we can also then bundle them with role-based variables, files, handlers and more.

Take a look at our playbook `playbook-pre-roles.yml`.

```yaml
---
- name: run cowsay-nginx
  hosts: all

  tasks:
  - name: Only run "update_cache=yes" if the last one is more than 3600 seconds ago
    ansible.builtin.package:
      update_cache: yes
      cache_valid_time: 3600

  - name: "Install Nginx"
    ansible.builtin.package:
      name: nginx
      state: present

  - name: "create www directory"
    file:
      path: /var/www/cowsay-site
      state: directory
      mode: '0775'
      owner: root #"{{ ansible_user }}"
      group: root #"{{ ansible_user }}"

  - name: delete default nginx site
    file:
      path: /etc/nginx/sites-enabled/default
      state: absent

  - name: copy nginx site.conf
    template:
      src: site/site.conf.j2
      dest: /etc/nginx/sites-enabled/cowsay-site
      owner: root
      group: root
      mode: '0644'

  - name: copy nginx index.html
    template:
      src: site/index.html
      dest: /var/www/cowsay-site
      owner: root
      group: root
      mode: '0644'

  - name: "start nginx"
    service:
      name: nginx
      state: started
      use: service  # disclaimer on this shit
```

This playbook installs a webserver called Nginx, and configures it with some custom configuration, then finally starts the server. The nitty details are not important to us, but as you can see, this playbook is starting to grow. It is also taking on the role of both installing nginx, and configuring it, and it is reasonable to assume that we might perhaps want to have a playbook that does one or the other of these things again in the future. Enter the stage...Roles!

---

## Exercise

Creating and implementing a role into your playbook is as simple as a command and some good old copy paste. However, the important thing to consider when creating one is making sure we document it well, so that it can be properly reused by ourselves and others down the line. That is for another exercise however.

As discussed before, our playbook covers two responsibilities, or two roles; installing nginx, and configuring nginx for cowsay. Lets split these into two roles.

1. initialise the roles by running the following commands:

```bash
ansible-galaxy init install-nginx
```

```bash
ansible-galaxy init configure-cowsay-nginx
```

2. Copy the related tasks to our new roles into the tasks folder so that they now look like:

`install-nginx/tasks/main.yml`

```yaml
---
# tasks file for install-nginx
  - name: Only run "update_cache=yes" if the last one is more than 3600 seconds ago
    ansible.builtin.package:
      update_cache: yes
      cache_valid_time: 3600

  - name: "Install Nginx"
    ansible.builtin.package:
      name: nginx
      state: present
```

`configure-cowsay-nginx/tasks/main.yml`

```yaml
---
# tasks file for configure-cowsay-nginx
  - name: "create www directory"
    file:
      path: /var/www/cowsay-site
      state: directory
      mode: '0775'
      owner: root #"{{ ansible_user }}"
      group: root #"{{ ansible_user }}"

  - name: delete default nginx site
    file:
      path: /etc/nginx/sites-enabled/default
      state: absent

  - name: copy nginx site.conf
    template:
      src: site/site.conf.j2
      dest: /etc/nginx/sites-enabled/cowsay-site
      owner: root
      group: root
      mode: '0644'

  - name: copy nginx index.html
    template:
      src: site/index.html
      dest: /var/www/cowsay-site
      owner: root
      group: root
      mode: '0644'
```

We can now look at the playbook `playbook-post-roles.yml`:

```yaml
---
- name: run cowsay-nginx
  hosts: all

  roles:
    - role: install-nginx
    - role: configure-cowsay-nginx

  tasks:
  - name: "start nginx"
    service:
      name: nginx
      state: started
      use: service  # disclaimer on this shit
```

We have introduced a new section called `roles` that consists of our two roles, on the same level hierarchy as the tasks section.

3. Run the playbook. *Remember to replace the HOST_IP like before.*

```bash
ansible-playbook -i HOST_IP, playbook-post-roles.yml --private-key ~/.ssh/id_rsa -u root
```

navigate to localhost:80 to see the result.

*Normally we would access a host machines ports for this result, not our Ansible machines localhost, but due to convenience in the training environment, such is life.*
