# Define an inventory File

This exercise will introduce you to hosts and the inventory file.

*Initialise the exercise by running `./setup.sh` inside of the exercise directory. Wait until you are placed inside the workspace directory in the exercise environment. If you want to reset your environment at any time, you can simply run the setup script again.*

## Introduction

Until now, we glossed over the `hosts: all` parameter in our plays. Simply put, a host is Ansible's name for a target machine we want to run tasks on, i.e. the machine we want to change. As you can imagine, we might have access to a massive amount of hosts, and run playbooks on several of these hosts at once. We do this by organising all our different hosts into an inventory file, then we can specify which hosts from the inventory file we want plays to run on. Can you now guess what `hosts: all` means?

## Inventory file

The inventory file is where we list our hosts' IP-address along with a desired tag or grouping so we can easily reference it from the playbook. For all possible inventory options see the [official documentation](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html).

Below is an example inventory file, called `hosts`, where we have created two groups; `group_1` and `group_2`. `hosts` is a common naming convention for your inventory file.

```ini
[group_1]
INSERT_IP_1_HERE

[group_2]
INSERT_IP_2_HERE
```

---

## Exercise

1. Open the `hosts` file. Insert the two IPs printed during setup into separate groups by replacing the `INSERT_IP_X_HERE` example text.

2. Open the `playbook.yml` file. Specify the play to run on one of the groups by changing `hosts: all` to `hosts: group_1`.

3. Run the playbook. This time there will be no need to edit the command with an IP address, as we will be using an inventory file instead.

``` bash
ansible-playbook -i hosts playbook.yml --private-key ~/.ssh/id_rsa -u root
```

4. Open the `playbook.yml` file once more. Specify the play to run on with `hosts: all` again. Run the playbook to see the difference.

In order to check the group we ran on, just for fun, we can set a variable that's specific for each group. Let's give them a "name" variable which is set to their group name, and then *cowsay* it during the playbook run to see which group of hosts were targeted.

5. Add the following to your hosts file:

```ini
[group_1]
INSERT_IP_1_HERE

[group_2]
INSERT_IP_2_HERE

## new content
[group_1:vars]
NAME=group_1

[group_2:vars]
NAME=group_2
```

6. add the following to your playbook.yml:

```yaml
---
- name: install cowsay
  hosts: all ##change hosts group here
  become: true
  vars:
    ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
  tasks:
    - name: Install cowsay
      ansible.builtin.package:
        name: cowsay
        state: present
        update_cache: yes
#new
    - name: Say something
      shell: |
        /usr/games/cowsay "I just ran on {{ NAME }}"
      register: out
    - debug: var=out.stdout_lines
```

7. Run the playbook again with different `hosts` values and see what output you get.

## Finishing up

After you are finished with this exercise, leave the training environment by either pressing ctrl+d or simply typing `exit` in your terminal.
