# Handlers

This exercise will introduce you to handlers.

*Initialise the exercise by running `./setup.sh` inside of the exercise directory. Wait until you are placed inside the workspace directory in the exercise environment. If you want to reset your environment at any time, you can simply run the setup script again.*

## Introduction

So far we have built our playbooks with tasks, and they always run sequentially in a playbook from top to bottom. Handlers are also just normal tasks, with the key difference that they do not run by default. They can be notified by other tasks and doing so will trigger them to run after the normal tasks are done. In other words, handlers are conditionally triggered tasks.

---

## exercise

1. Take a look at our `playbook.yml`

We can see our familiar "Install Cowsay" task, but now with a `notify` block. This block is a list where we put all the handlers we want that task to notify if the task experiences changes. We also see the new `handlers` section on the same indentation level as `tasks`. This is where we define our handlers in exactly the same way as any task.

2. run the playbook with the following command: *Remember to replace the HOST_IP like before.*

```bash
ansible-playbook -i HOST_IP, playbook.yml --private-key ~/.ssh/id_rsa -u root
```

We see that the handlers run after all the tasks are done executing, which in this case is only one. What would happen if we ran the playbook again now?

3. try running the playbook again. Cowsay is already installed, and now our handlers won't execute as nothing changes in the `Install Cowsay` task anymore, thus causing the task to not notify.

### flushing handlers

The `meta: flush_handlers` task triggers any handlers that have been notified at that point in the play. So if you want a service restart handler to run before the playbook continues, you can insert the task below into your playbook at the point you want notified handlers up until that point to run.

4. Take a look at `flush_example_playbook.yml`:

```yaml
---
- name: Flush example
  hosts: all
  become: yes

  handlers:
    - name: handler 1
      shell: |
        echo "I'm a little handler"
      register: out

    - name: handler 2
      ansible.builtin.debug:
        msg: "{{ out.stdout_lines }}"

  tasks:
    - name: Task 1
      shell: |
        echo "example run"
      notify:
        - handler 1

    - name: Flush handlers
      meta: flush_handlers

    - name: Task 2
      shell: |
        echo "example run two"
      notify:
        - handler 2

```

How do you think this playbook will execute?

2. run the playbook with the following command: *Remember to replace the HOST_IP like before.*

```bash
ansible-playbook -i HOST_IP, flush_example_playbook.yml --private-key ~/.ssh/id_rsa -u root
```

We should see that `handler 1` ran before the end of the playbook, as it was triggered before the flush task, which triggered a run by `Flush handlers`. `Handler 2` then proceeded to run at the end of the playbook as normal.

### extras

A playbook can be ran with --force-handlers tag to make handlers run even if a playbook fails.

Handlers from roles are not just contained in their roles but rather inserted into global scope with all other handlers from a play. As such they can be used outside of the role they are defined in. It also means that their name can conflict with handlers from outside the role. To ensure that a handler from a role is notified as opposed to one from outside the role with the same name, notify the handler by using its name in the following form: role_name : handler_name.

Read more in the [handlers documentation here](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_handlers.html).
