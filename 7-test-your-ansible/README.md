an exercise that goes through the basic sanity test steps. perhaps these should be broken up into two, the linting and the molecule.

1. is it valid yaml? yamllint
2. is it valid ansible? ansible-test
3. unit tests
4. integration test ? molecule



With existing role:
    molecule init scenario -r install-nginx
    molecule init scenario -r cowsay-nginx-configuration
without existing role: 
    molecule init role --driver-name docker some_namespace.install_nginx

This will create a default Molecule testing scenario within each role's directory.
Now let's set up a basic test for the install-nginx role.
Navigate to the install-nginx/molecule/default directory, where you will find a converge.yml file, which is the playbook that Molecule will run against its instance. In this case, it might look something like:

some deps:

    ansible-galaxy collection install community.docker
    python3 -m pip install --user "molecule-plugins[docker]"
