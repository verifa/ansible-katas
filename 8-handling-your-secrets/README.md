# Handling your secrets

This exercise will introduce you to ansible-vault and how to use it for secret management.

*Start by initialising the exercise by running ./setup.sh while inside of this exercise folder, and wait until you are put inside the workspace folder of the exercise environment. If you want to reset your environment at any time you can simply run the setup script again.*

## Ansible vault

When we use playbooks for real business applications, it is likely that we might need to utilise some very sensitive data during our runs. With ansible-vault we can create files that hold all the neccesary secrets for our playbooks in an encrypted form. Ansible-vault can then utilize these encrypted values during a run, given that you provide the right password for the file that you gave on file creation. Since the file is encrypted, we can even store it alongside our playbooks in version control if we like. You should, if possible, store the ansible-vault file password inside something like hashicorp vault when working in a team.

---

## Exercise

Let's start by creating our ansible-vault file.

1. Run the following command:

```bash
ansible-vault create my-first-vault.yml
```

You will be prompted to add a password. This is the password that will protect the contents of your file, so in a professional setting, this password should either be written to a protected file on your ansible machine, or preferably stored in some shared secret manager like Hashicorp Vault. We will need to remember our password for later.

*You will be presented with a Nano window. If youre unfamiliar with this text editor, you can get some help from the [documentation here](https://www.nano-editor.org/dist/v2.2/nano.html). TLDR: control+x to save, answer yes to the prompt and press enter to close.*

2. Copy the content below into the nano window. Replace `name` and `value` with something of your choosing, just make sure you remember them for later.

```yaml
---
name: "value"
```

After saving and closing the Nano window, we can take a look at how the file actually looks on our computer now.

3. Run the following command:

```bash
cat my-first-vault.yml
````

We can see that our file is encrypted! The only way to see our value now is to decrypt it with our previously set password.

![encrypted file output](/.utils/assets/handling-your-secrets_encrypted_file.png)

Let's now try to use our earlier created secret in an actual playbook.

4. Take a look at our example playbook `playbook.yml`

It's our old trusty cowsay playbook, but with some small modifications.

```yaml
- name: install cowsay
  hosts: all
  become: yes
  vars_files: # new
    - my-first-vault.yml # new
# ...
```

We have added `vars_files` and as a list entry we added our `my-first-vault.yml`. A little further down we can see that our cow is trying to say something. You can reference values from an ansible-vault file using double brackets like {{ this }}.

```yaml
# ...
    - name: Say something
      shell: |
        /usr/games/cowsay {{ INSERT_SECRET_NAME_HERE }}
      register: out
    - debug: var=out.stdout_lines
```

5. Replace the placeholder `INSERT_SECRET_NAME_HERE` value with the name you gave your vault secret. (if you forgot the name you gave, you can edit an ansible vault after creation. See [documentation here](https://docs.ansible.com/ansible/2.8/user_guide/vault.html)).

The time has come to see if Ansible can successfully read the encrypted value in your ansible-vault file and use it in the playbook.

6. Run the playbook: *Remember to replace the HOST_IP like before.*

```bash
ansible-playbook -i HOST_IP, playbook.yml --private-key ~/.ssh/id_rsa --ask-vault-pass -u root
```

Notice the new `--ask-vault-pass` flag added. This makes Ansible prompt us for a password to our specified ansible-vault files on playbook execution. For alternative ways to use vault, see [documentation](https://docs.ansible.com/ansible/2.8/user_guide/vault.html).

If everything was done correctly, we should see some output where our cow is yelling out our secret value. Great!
