# Ansible Training

In this repository you will find free hands-on exercises that you can download and repeat as many times as you like. Their intended purpose is to teach you the basics of Ansible, as well as how to work with best practices once you've mastered the basics.

*There is an assosciated workshop available for this material. Reach out to Verifa at [verifa.io](https://verifa.io/contact/) for more information!*

---
## Dependencies

To run these exercises you will need to have [Docker](https://www.docker.com/) installed.

## Getting started

1. Clone the repository

2. Navigate to the folder of the exercise you want to run.

3. Run the setup.sh script inside of the exercise folder with the command:

```bash
./setup.sh
```

*this might initially take a few minutes, but will only take a few seconds for subsequent runs.*

You will now be inside the training environment workspace, ready to go!

## Usage

In each exercise folder you will find a README.md, a setup.sh script, and a workspace folder.

### README.md

the README will contain your exercise, covering exercise steps, explanations, and examples.

### Setup.sh

The setup.sh should be run before every exercise. It will clean up any previous exercise environment, and spin up the relevant one for the exercise folder you are currently in. When complete, it will put you inside of your exercise workspace in the training environment, and you can start your exercise.

### workspace folder

the workspace folder acts as a link between your training environment and your local computer. Anything you create inside the workspace folder on the training environment will also exist on the folder on your computer, and vice versa. This means that while working, you can open the workspace folder in whatever editor you prefer on your local computer, and perform any needed file changes there, and it will appear inside the training environment.

---

## Contact

This project is open source and any feedback is welcomed in the form of issues.

For any questions regarding a full training workshop on Ansible for your company or team, contact Verifa at [verifa.io](https://verifa.io/contact/)
