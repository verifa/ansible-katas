
######## THIS STUFF MIGHT BE DELETED, JUST TAKING NOTES ###########

### Installing Molecule

First of we need to install the Molecule CLI:

```bash
python3 -m pip install --user molecule
```

Then for the excerices we use the docker plugin, which is installed separately:

```bash
python3 -m pip install --user "molecule-plugins[docker]"
```

Molecule journey starts of great, the cli itself doesn't work but running as python module works:

```
> molecule init scenario
zsh: /opt/homebrew/bin/molecule: bad interpreter: /opt/homebrew/opt/python@3.9/bin/python3.9: no such file or directory
> python3 -m molecule init scenario
#OK!
```

After init there's a new folder called `molecule` with a single scenario underneath, called `default`:

```bash
molecule
└── default
    ├── converge.yml
    ├── create.yml
    ├── destroy.yml
    └── molecule.yml
```

There's two main commands you use with `molecule`:

```
molecule test
```

```
molecule converge
```

The `test` subcommand is used to run the scenario and cleanup afterwards. The `converge` command is useful when developing since it skips the cleanup, allowing you to modify your role and then retrying, although arguably every now and then you might want to reset and start from scratch.

### Shit ain't working

So after initialising the scenario (molecule init scenario) the default scenario fails to really do anything. After some head scratching I figured there's a `create.yml` file, which I've not used in the past. This file can be used to build your "platforms"/instances by using Ansible directly, but I find that's quite an advanced an unnecessary. After removing that file, the Docker driver starts to work and builds the images as per spec. This seems like a super weird default, but looking at the docs there's an example of modifying the `create.yml` to make it work: <https://ansible.readthedocs.io/projects/molecule/docker/>. I guess the authors of the project prefer doing it themselves, but I disagree.

It was the same story with `destroy.yml` naturally.
