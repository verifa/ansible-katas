
# Intro 
> intro to roles and their advantages. yada yada...As our playbooks grow, we can separate them out into logical groupings called roles, which we can then bundle with role-based variables, files, tasks, handlers and more. Our playbook will then consist of running a selection of roles, and the individual roles will contain the actual task implementations. this makes them reusable by other playbooks etc etc. 

Take a look at our playbook "playbook-pre-roles.yml".

```yaml
---
- name: run cowsay-nginx 
  hosts: all

  tasks: 
  - name: Only run "update_cache=yes" if the last one is more than 3600 seconds ago
    ansible.builtin.apt:
      update_cache: yes
      cache_valid_time: 3600

  - name: "Install Nginx"
    ansible.builtin.apt:
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

This playbook installs a webserver called Nginx, and configures it with some custom configuration, and finally starts the server. The nitty details are not important to us, but as you can see, this playbook is starting to grow. It is also taking on the role of installing nginx, and configuring it. It is reasonable to assume that we might perhaps want to have a playbook that installs or configures nginx in the future as well. Perhaps only one of them.

> continue explanation or whatever...


## exercise

* initialise the roles

create role boiler plate
>$ ansible-galaxy init install-nginx

>$ ansible-galaxy init configure-cowsay-nginx

Copy the related tasks to our new roles into the tasks folder so that they now look like:

```yaml
insert example role tasks here too lazy atm. TODO:
```

If we now look at the playbook "playbook-post-roles.yml":

```yaml
---
handlers:
- name: restart nginx
  service:
    name: nginx
    state: restarted

- name: install nginx
  hosts: all
  become: true
  roles:
  - install-nginx

- name: Configure nginx
  hosts: all
  become: true
  roles:
  - configure-cowsay-nginx
  notify: restart nginx
```


>explanation of how the playbook looks now.

try to run the playbook and then we will navigate to the url and see if our webserver is now correctly serving.

```
ansible-playbook -i HOST_IP, playbook-post-roles.yaml --private-key ~/.ssh/id_rsa -u root
```

navigate to localhost:80 to see the result.

> side explanation of why its localhost and not the ip adress of the target. yada yada consequence of our demo environment.


### extras
Always use descriptive names for your roles, tasks, and variables. Document the intent and the purpose of your roles thoroughly and point out any variables that the user has to set. Set sane defaults and simplify your roles as much as possible to allow users to get onboarded quickly.
Never place secrets and sensitive data in your roles YAML files. Secret values should be passed to the role at execution time by the play as a variable and should never be stored in any code repository.
At first, it might be tempting to define a role that handles many responsibilities. For instance, we could create a role that installs multiple components, a common anti-pattern. Try to follow the separation of concerns design principle as much as possible and separate your roles based on different functionalities or technical components.
Try to keep your roles as loosely coupled as possible and avoid adding too many dependencies. 
To control the execution order of roles and tasks, use the import_role or Include_role tasks instead of the classic roles keyword.
When it makes sense, group your tasks in separate task files for improved clarity and organization.


