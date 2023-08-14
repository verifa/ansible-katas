# Intro

>explanation of how we might have many hosts. We might want to categorise them and be able to specify in our playbooks what host groupings we want the playbook to run on. queue inventory file.

## exercise
>give them the example hosts file.

```toml
[group_1]
INSERT_IP_1_HERE

[group_2]
INSERT_IP_2_HERE
```
1. Have them insert the generated ips from the setup script into separate groups.
2. specify the playbook to run on one of the groups, run the playbook.
3. specify the playbook to run on the "all" tag, and see the difference.

run the playbook: (note the difference in the command from previous runs as we are now pointing to a hosts file rather than specific ips.) TODO: when running here it can be a bit glitchy as it asks for the known hosts confirmation on  both ssh connections, gotta find a nice workaround to make this a bit more clean.
```
ansible-playbook -i hosts playbook.yaml --private-key ~/.ssh/id_rsa -u root
```
In order to see check what group we ran on, just for fun, we can set a variable thats specific for each group. Lets give them a "name" variable that is set to their group name, and then have the cow speak it during the playbook run to see which group of hosts were targeted.

4. Add the following to your hosts file:

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

5. add the following to your playbook.yaml:

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

6. Run the playbook again with different hosts values and see what output you get.
