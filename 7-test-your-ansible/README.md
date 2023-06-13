an exercise that goes through the basic sanity test steps. should maybe come earlier?

1. is it valid yaml? yamllint
2. is it valid ansible? ansible-test

??????
3. unit tests
4. integration test
??????


    molecule init scenario -r install-nginx
    molecule init scenario -r cowsay-nginx-configuration

This will create a default Molecule testing scenario within each role's directory.
Now let's set up a basic test for the install-nginx role.
Navigate to the install-nginx/molecule/default directory, where you will find a converge.yml file, which is the playbook that Molecule will run against its instance. In this case, it might look something like:

    ---
    - name: Verify
    hosts: all
    tasks:
        - name: Check if nginx is installed
        command: which nginx
        changed_when: false
        - name: Check if nginx is running
        systemd:
            name: nginx
            state: started
        register: service_status
        - assert:
            that:
            - 'service_status.status == "running"'
            fail_msg: "nginx is not running"
            success_msg: "nginx is running"