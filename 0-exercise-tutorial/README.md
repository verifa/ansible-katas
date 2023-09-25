# Exercise tutorial

We have created an isolated training environment for these Ansible exercises, thus making it only required to have docker installed to run. The isolated environment will serve as a guardrail in case you manage to run some Ansible that will detrimentally change some state on the target machine. In such a case you can simply run the script that creates the environment again, and it will remove the old one and create a fresh new one. The environment will also provide some simulated machines to run your exercises against.

## how to start

1. navigate to the folder of the exercise you want to run.

2. run the setup.sh script inside of the exercise folder by copying the command below(this might take a few minutes your first time, but will only take a few seconds for the rest of the exercises.)

```bash
./setup.sh
````

You will now be inside the training environment workspace, ready to go!

In each exercise folder you will find a README.md, a setup.sh script, and a workspace folder.

### README.md

the readme will contain your exercise, including exercise steps, explanations, and examples.

### Setup.sh

The setup.sh should be run before every exercise, as mentioned in the step-by-step above. It will clean up any previous exercise environment, and spin up the relevant one for the exercise folder you are currently in. When complete, it will put you inside of your exercise workspace in the training environment, and you can start your exercise.

### workspace folder

the workspace folder acts as a link between your training environment and your local computer. Anything you create inside the workspace folder on the training environment will also exist on the folder on your computer, and vice versa. This means that while working, you can open the workspace folder in whatever editor you prefer on your local computer, and perform any needed file changes there, and it will appear inside the training environment as well.
