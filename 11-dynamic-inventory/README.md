# Dynamic Inventory

This exercise will introduce you to using dynamic inventories instead of static files to track hosts.

*Start by initialising the exercise by running ./setup.sh while inside of this exercise folder, and wait until you are put inside the workspace folder of the exercise environment. If you want to reset your environment at any time you can simply run the setup script again.*

## What's a Dynamic Inventory?

Maintaining an inventory file might be ok when starting out, experimenting and learning. But commonly you will quickly grow in scale and need some dynamic way to track hosts when new servers/VMs are created in your environment. Luckily Ansible has a large number of dynamic [inventory plugins](https://docs.ansible.com/ansible/latest/collections/index_inventory.html). For this exercise we will use the [Dynamic Inventory Plugin for Docker containers](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_containers_inventory.html#ansible-collections-community-docker-docker-containers-inventory), this plugin will query the local Docker socket and gather information about all the containers running in the system.

*You can also build your own custom plugins, with the only requirement that you actually have a data source (typically an API of some sort) that you can use to make calls to and gather a list of hosts.*

---

## Exercise

> **NOTE:** This excercise connects directly to the Docker socket which is disabled by default in recent Docker Desktop versions. You can alter this setting in the advanced settings in the GUI. It's recommended to turn it off after the exercise for security reasons (any process/user with access to the socket has effectively `root` access on the machine)

Before jumping into how to use the Dynamic Inventory plugin with a playbook, it's good to get to know what configuration options the plugin has and how you can group nodes given the information available from the data source (Docker in this case).

1. First let's add the configuration for the inventory plugin to `local.docker.yml`:

```yaml
#local.docker.yml
plugin: community.docker.docker_containers
docker_host: unix://var/run/docker.sock
```

2. We can now play around with the `ansible-inventory` CLI to understand what kind of inventory it creates. Run the commands below:

```bash
ansible-inventory -i local.docker.yml --graph
# OR
ansible-inventory -i local.docker.yml --list
```

You will notice that there are few groups, but none really work for us currently if we want to target only the `ansible_katas_host_x` containers with our playbook. In order to do that we need to modify the configuration file `local.docker.yml` to dynamically build a convenient group name.

### Dynamic Groups

One of the challenges with Docker itself is that it does not have a concept like tags which is common way to group and query hosts/nodes in cloud providers such as AWS or Azure. So for the purpose of this exercise we will use a special environment variable `GROUP` which is injected into the `ansible_katas_host_x` containers by `docker-compose` during bootup.

3. Modify the `local.docker.yml` to lookup the environment variables for all the containers it finds and then create groups named based on the environment variables:

```diff
 plugin: community.docker.docker_containers
 docker_host: unix://var/run/docker.sock
+keyed_groups:
+  - prefix: env
+    key: 'docker_config.Env'
```

4. Now re-run the command to list the groups and see if there's a group that would only include the `ansible_katas_host_1` and `ansible_katas_host_2` containers:

```bash
ansible-inventory -i local.docker.yml --graph
```

Look for the `GROUP` environment variable and it's value, showing up as `env_GROUP_hosts`. Next we can use that group in a playbook, just like in the example playbook `playbook.yml`

### Executing Playbooks with Dynamic Inventory

Now, let's finally execute a test playbook by utilising the dynamic inventory.

5. Run the command below:

```bash
ansible-playbook --inventory local.docker.yml playbook.yml
```

As you see, the inventory plugin's configuration is simply passed as the inventory "file" and the plugin is invoked before the playbook runs. This makes sure the inventory is always up-to-date when we execute the playbook.

### Dynamic Hostvars

The inventory plugin has also gathered some extra details about the hosts after the run.

6. Run the list command again to see what data we have available now:

```bash
ansible-inventory -i local.docker.yml --list
```

```json
{
    "_meta": {
        "hostvars": {
            "ansible_katas_host_1": {
                "ansible_connection": "community.docker.docker_api",
                "ansible_docker_api_version": "auto",
                "ansible_docker_docker_host": "unix://var/run/docker.sock",
                "ansible_docker_timeout": 60,
                "ansible_docker_tls": false,
                "ansible_docker_use_ssh_client": false,
                "ansible_docker_validate_certs": false,
                "ansible_host": "ansible_katas_host_1",
                "docker_name": "ansible_katas_host_1",
                "docker_short_id": "86229a9871f6a"
            },
...
```

In the case of the Docker plugin this information isn't super useful, but make sure to review these when using a plugin since they can be useful in playbooks.
