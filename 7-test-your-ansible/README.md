# Test Your Ansible

This exercise will introduce you to basic YAML and Ansible lint testing with yamllint and ansible-lint.

*Start by initialising the exercise by running ./setup.sh while inside of this exercise folder, and wait until you are put inside the workspace folder of the exercise environment. If you want to reset your environment at any time you can simply run the setup script again.*

## Introduction

Thankfully, there are tools in the world that help us with testing, making this very important process relatively painless. When setting up our tests, it is a good idea to start with the easiest and quickest to perform ones, so that we don't waste many minutes trying to run an integration test just to have our automated test pipeline fail on something that a one second linter would catch. In this exercise we will take a look at these quicker, handy test tools. If youre looking for heavier unit and integration testing, you should look to Molecule. Which we will coincidentally cover in a later exercise.

## Exercise

The mother of all quick and easy tests is the linter. A linter checks your document against a defined set of rules to make sure it adheres to them, which is very convenient for catching syntax and style errors. In this exercise we will use yamllint to check for YAML sins, as well as ansible-lint for crimes against ansible.

### yamllint

1. install yamllint with the following command:

```bash
apt-get install yamllint
```

2. run yamllint on our playbook with the following command:

```bash
yamllint playbook.yml
```

You should be met with a selection of errors and warnings similar to below.

*insert image here of yamllint output*

If you include yamllint in your automation pipelines, its worth noting that errors will cause an error code but warnings do not. Yamllint's rules and warning levels are fully customisable in a config file, but for this exercise we will simply use the defaults.

3. Try to fix the errors from the linter. You can always run the above command again to check your progress.

### ansible-lint

Now that we have tried out yamllint and have made sure that our playbook at least is valid and properly styled YAML, we should move on to validate that it is solid ansible as well.

4. Install ansible-lint with the following command:

```bash
pip3 install ansible-lint
```

*We can alter ansible-lints rules and preferences with a config file, but for this exercise we will continue with the defaults.*

5. Let's run the below command to lint all playbooks in your working directory:

```bash
ansible-lint
```

*insert image of ansible-lint errors here*

6. As before, try to fix any errors the linter provides you.
