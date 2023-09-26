# Define an Inventory File

This exercise will introduce you to hosts and the inventory file.

*Start by initialising the exercise by running ./setup.sh while inside of this exercise folder, and wait until you are put inside the workspace folder of the exercise environment. If you want to reset your environment at any time you can simply run the setup script again.*

## Introduction

We have until now glossed over the `hosts: all` parameter seen in our plays. Simply put, a host is ansibles name for the target machine we want the tasks to execute on, ie; the machine we want to change. As you can imagine, in the real world we might have access to a massive amount of different hosts, and we might have playbooks that we want to be able to run on several of these hosts at once. We do this by organising all our different hosts into one file, called an `inventory`, and then we specify in the playbook which hosts from the inventory file we want the play to run on. Can you guess now what `hosts: all` means?

## Inventory file

The inventory file is a TOML-file where we can insert our hosts ip-address along with a desired tag or grouping for that host so that we can easily reference it from the playbook. For all possible inventory options see [here](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html).

Below is an example inventory file where we have created two groups; `group_1` and `group_2`. This file also exists inside our exercise workspace as `hosts`, which is a common naming convention for your inventory file.

```toml
[group_1]
INSERT_IP_1_HERE

[group_2]
INSERT_IP_2_HERE
```

## Exercise

1. Open the `hosts` file. Insert each of the two generated ips from your terminal during setup into separate groups by replacing the `INSERT_IP_X_HERE` example text.

2. Open the `playbook.yml` file. Specify the play to run on one of the groups by changing `hosts: all` to `hosts: group_1`.

3. Run the playbook with the command below. This time there will be no need to edit the command with an ip adress, as we will be using an inventory file.

``` bash
ansible-playbook -i hosts playbook.yml --private-key ~/.ssh/id_rsa -u root
```

*note the difference in the command from previous runs as we are now pointing to a hosts file rather than a specific ip.*

4. Open the `playbook.yml` file once more. Specify the play to run on the `hosts: all` tag again. Run the playbook to see the difference.

In order to see check what group we ran on, just for fun, we can set a variable thats specific for each group. Lets give them a "name" variable that is set to their group name, and then have the cow say it during the playbook run to see which group of hosts were targeted.

5. Add the following to your hosts file:

```toml
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
  become: yes
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

7. Run the playbook again with different hosts values and see what output you get.
