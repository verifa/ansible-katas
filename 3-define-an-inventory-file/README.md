# Intro

>explanation of how we might have many hosts. We might want to categorise them and be able to specify in our playbooks what host groupings we want the playbook to run on. queue inventory file. 

## exercise 
>give them the example hosts file. Have them insert the ips into separate groups, then specify the playbook to run on one of the groups, then on the "all" tag, and see the difference. 
```toml
[group_1]
INSERT_IP_1_HERE

[group_2]
INSERT_IP_2_HERE
```
run the playbook: (note the difference between previous runs as we are now pointing to a hosts file rather than specific ips.)
```
ansible-playbook -i hosts playbook.yaml --private-key ~/.ssh/id_rsa -u root
```
In order to see check what group we ran on, just for fun, we can set a variable thats specific for each group. Lets give them a "name" variable that is set to their group name, and then have the cow speak it during the playbook run to see which group of hosts were targeted. add the following to your hosts file:

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

and the following to your playbook.yaml:

```yaml
---
- name: install cowsay
  hosts: all ##change hosts group here
  become: yes
  tasks:
    - name: Install cowsay
      ansible.builtin.apt:
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

Run the playbook again with different hosts values and see what output you get.