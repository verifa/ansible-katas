# Use a Collection

This exercise will introduce you to collections and how to use them.

## What are Collections?
Collections are a distribution format for Ansible content that can include playbooks, roles, modules, and plugins. You can install and use collections through a distribution server, such as [galaxy.ansible.com](https://galaxy.ansible.com).

In our last exercise we created a role for installing nginx. However it is safe to assume we probably reinvented the wheel on this one. We can go to [galaxy.ansible.com](https://galaxy.ansible.com) to see what collections and roles people have uploaded before. There we find Nginx [official collection](https://galaxy.ansible.com/nginxinc/nginx_core) that contains handy roles for installing and working with Nginx.

## Exercise

*Start by initialising the exercise by running ./setup.sh while inside of this exercise folder, and wait until you are put inside the workspace folder of the exercise environment. If you want to reset your environment at any time you can simply run the setup script again.*

1. Install the Nginx official collection by running the command below:

```
ansible-galaxy collection install nginxinc.nginx_core
```

2. We can now list our installed collections to see what we have available. Run the following command:
```
ansible-galaxy collection list
```

3. To see where our collections ended up, we can have a look at `/root/.ansible/collections/ansible_collections/`.

Lets install Nginx on our host by importing the nginx installer role from the collection to our playbook.

4. Take a look at the playbook.yml.

```yaml
---
- name: run nginx
  hosts: all

  collections:
    - nginxinc.nginx_core

  tasks:
  - name: Install nginx
    ansible.builtin.import_role:
      name: nginx

  - name: "start nginx"
    service:
      name: nginx
      state: started
      use: service

```

We have imported our previously downloaded collection into the playbook with the lines below:

```yaml
  collections:
    - nginxinc.nginx_core
```
and then imported a role from that collection under the `tasks` section.

5. Run the playbook with the command below:

```
ansible-playbook -i HOST_IP, playbook.yml --private-key ~/.ssh/id_rsa -u root
```
*Remember to replace IP adress like before!*


*if you receive an error that "service is in an unkown state", try running the playbook again. It is likely that the role is trying to start the service before it has fully installed yet and thus encounters the error.*

5. Navigate to localhost:80 to see if we encounter the default nginx page, indicating that nginx was installed and started successfully.

For an extensive list of how you can utilize collections and uploaded roles, see the [official collection documentation](https://docs.ansible.com/ansible/latest/collections_guide/index.html).
