
explanation of why roles in progress
as our playbooks grow, we can separate them out into logical groupings called roles, which we can then have role-based variables, files, tasks, handlers and more based on the ansible role structure. Our playbook will then consist of running a selection of roles, and then the individual roles will have the logic. this makes them reusable by other playbooks etc etc. 

create role boiler plate
$ ansible-galaxy init test-role-1

explain how we now will have a main.yml and then call roles


exercise idea:
have a big playbook with tasks that are logically separatable to roles. have them create the role structure with abovecommand, then refactor the tasks into the different roles. how do we validate?

are they given the final main playbook 

Always use descriptive names for your roles, tasks, and variables. Document the intent and the purpose of your roles thoroughly and point out any variables that the user has to set. Set sane defaults and simplify your roles as much as possible to allow users to get onboarded quickly.
Never place secrets and sensitive data in your roles YAML files. Secret values should be passed to the role at execution time by the play as a variable and should never be stored in any code repository.
At first, it might be tempting to define a role that handles many responsibilities. For instance, we could create a role that installs multiple components, a common anti-pattern. Try to follow the separation of concerns design principle as much as possible and separate your roles based on different functionalities or technical components.
Try to keep your roles as loosely coupled as possible and avoid adding too many dependencies. 
To control the execution order of roles and tasks, use the import_role or Include_role tasks instead of the classic roles keyword.
When it makes sense, group your tasks in separate task files for improved clarity and organization.