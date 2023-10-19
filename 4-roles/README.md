# Roles

This exercise will introduce you to roles and their applications.

*Initialise the exercise by running `./setup.sh` inside of the exercise directory. Wait until you are placed inside the workspace directory in the exercise environment. If you want to reset your environment at any time, you can simply run the setup script again.*

## What are Roles?

As our playbooks grow in size and number, we might want to separate tasks into reusable logical groupings, which Ansible calls "Roles". I imagine the name alludes to the way an actor would take on a role in a play, as it doesn't have anything to do with permissions. Our playbook will consist of a selection of roles, and the roles will contain the actual task implementations. This is great if you have a large number of playbooks reusing similar tasks, as you now have a single point to change these tasks. When we group together tasks into a role, we can also bundle them with role-based variables, files, handlers and more.

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
      use: service
```

This playbook installs a web server called *nginx*, and configures it with some custom configuration, then finally starts the server. The details are not important to us, but as you can see, this playbook is starting to grow. It's also taking on the role of both installing *and* configuring nginx. It is reasonable to assume we might want to have a playbook that does one or the other of these things again in the future. Enter the stage... Roles!

---

## Exercise

Creating and implementing a role is as simple as running a command and some good old copy-paste. However, the important thing when creating a role is documenting it well, so that it can be properly reused by ourselves and others down the line. That, however, we leave for another exercise.

As discussed before, our playbook covers two responsibilities, or two roles; installing nginx, and configuring nginx. Lets split these into two roles.

1. Initialise the roles by running the following commands:

```bash
ansible-galaxy init install-nginx
```

```bash
ansible-galaxy init configure-cowsay-nginx
```

2. Copy the related tasks to our new roles into the tasks directory so that they now look like:

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
      use: service
```

We have introduced a new section called `roles` that consists of our two roles, on the same level hierarchy as the tasks section.

3. Run the playbook. *Remember to replace the HOST_IP like before.*

```bash
ansible-playbook -i HOST_IP, playbook-post-roles.yml --private-key ~/.ssh/id_rsa -u root
```

Navigate to localhost:80 to see the result.

*Normally we would access a host machine's ports for this result, not our Ansible machine's localhost, but due to convenience in the training environment, such is life.*

## Finishing up

After you are finished with this exercise, leave the training environment by either pressing ctrl+d or simply typing `exit` in your terminal.
