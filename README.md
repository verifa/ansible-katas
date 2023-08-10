# Welcome to ansible katas

<em>Most documentation in this repository can be considered placeholder as we are still finalising what the exercises and the kata repository in general will look like. </em>

Feedback in the form of issues would be great :^).

In this repository you will find repeatable exercise katas that you can download and repeat as many times as you like. Their intended purpose is to teach you the basics of Ansible, as well as how to work with best practices once you've mastered the basics.

We have created an isolated training environment for these exercises, thus making it only required to have docker installed to run. The isolated environment will serve as a guardrail in case you manage to run some Ansible that will detrimentally change some state on the target machine. In such a case you can simply run the script that creates the environment again, and it will remove the old one and create a fresh new one. The environment will also provide some simulated machines to run your exercises against.

## how to start

1. navigate to the folder of the exercise you want to run.
2. run the setup.sh script inside of the exercise folder (this might take a few minutes your first time, but will only take a few seconds for the rest of the exercises.)
>./setup.sh
3. You will now be inside the training environment workspace, ready to go!


In each exercise folder you will find a README.md, a setup.sh script, and a workspace folder.

### README.md

the readme will contain your exercise, including exercise steps, explanations, and examples.

### Setup.sh

The setup.sh should be run before every exercise, as mentioned in the step-by-step above. It will clean up any previous exercise environment, and spin up the relevant one for the exercise folder you are currently in. When complete, it will put you inside of your exercise workspace in the training environment, and you can start your exercise.

### workspace folder

the workspace folder acts as a link between your training environment and your local computer. Anything you create inside the workspace folder on the training environment will also exist on the folder on your computer, and vice versa. This means that while working, you can open the workspace folder in whatever editor you prefer on your local computer, and perform any needed file changes there, and it will appear inside the training environment as well.
