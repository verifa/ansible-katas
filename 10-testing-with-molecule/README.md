# Testing with Molecule

This exercise will introduce you to Molecule.

*Initialise the exercise by running `./setup.sh` inside of the exercise directory. Wait until you are placed inside the workspace directory in the exercise environment. If you want to reset your environment at any time, you can simply run the setup script again.*

## Introduction

In our previous test exercise we ran some basic linting. However some more extensive testing is needed if we want to work safely in a production environment.

Molecule is a testing tool that allows you to configure default or customised target machines and tests. Then on test execution Molecule spins up target machines and run the tests you configured against the hosts, while also checking for things such as idempotence. This means you could customise your target machines to look like your production environment, and use molecule to test your playbooks locally or in a CI/CD pipeline without having to run it against production! Let's try it out.

---

## Getting started

We can initialize our Molecule structure with the following command, but for the purpose of this exercise it has already been done for us.

```bash
python3 -m molecule init scenario
```

We should then see a new directory called `molecule` with a single scenario underneath, called `default`:

```bash
molecule
└── default
    ├── converge.yml
    ├── create.yml
    ├── destroy.yml
    └── molecule.yml
```

Molecule offers you the ability to fully customise your test targets, however for this exercise we will use the Docker driver of Molecule with mostly it's default settings which are all contained in the `molecule.yml` file. The `create.yml` and `destroy.yml` are responsible for the custom test target configuration, and we would need to implement the creation and deletion logic for hosts in them, or we can just delete the files... So let's do that!

1. Delete the `create.yml` and `destroy.yml` files.

```bash
rm molecule/default/create.yml molecule/default/destroy.yml
```

You should also find a roles directory that is included in this exercise. This is the role we will be testing. If we look into `converge.yml` we can see that we specify molecule to run our nginx role.

## Using molecule

There's two main commands you use with `molecule`:

```bash
molecule test
```

```bash
molecule converge
```

The `test` subcommand is used to run the scenario and cleanup afterwards. The `converge` command is useful when developing since it skips the cleanup, allowing you to modify your role and then retrying, although arguably every now and then you might want to reset and start from scratch.

2. Run the molecule test command

```bash
molecule test
```

There's quite a lot of output, but we should see that Molecule creates two instances.

![molecule instance creation output](/.utils/assets/molecule1.png)

If everything goes smoothly, we should also see it perform two runs. The second run is to test idempotence, meaning that the tasks should all return an "OK" status on the second run.

![molecule idempotence output](/.utils/assets/molecule2.png)

 A "CHANGED" status would indicate that either our task does not have proper checks in place to confirm its own status, or that our task is written poorly, and is altering something on the machine even after it should already have been done on the first run.

## Finishing up

After you are finished with this exercise, leave the training environment by either pressing ctrl+d or simply typing `exit` in your terminal.
