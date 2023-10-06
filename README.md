# Ansible Training

In this repository you will find free hands-on exercises that you repeat as many times as you like. Their intended purpose is to teach you the basics of Ansible, as well as some best practices once you've mastered the fundamentals.

*There is an associated workshop available for this material. Reach out to Verifa at [verifa.io](https://verifa.io/contact/) for more information!*

---

## Dependencies

Running these exercises requires you to have [Docker](https://www.docker.com/) installed.

## Getting started

1. Clone the repository
2. Navigate to the directory of the exercise you want to run
3. Run the `setup.sh` script inside of the exercise directory:

```bash
./setup.sh
```

*The initial run might take a few minutes, but subsequent runs will be faster.*

You will now be inside the training environment workspace, ready to go!

## Usage

In each exercise directory you will find a `README.md` file, a `setup.sh` script, and a workspace directory.

### README.md

The `README.md` file contains the exercise itself, covering steps, explanations, and examples.

### setup.sh

The `setup.sh` script should be run before every exercise. It spins up the environment for the current exercise, as well as cleaning up any previous environments. When complete, it will put you inside the exercise workspace in the training environment, and you can start your exercise.

### Workspace

The workspace directory acts as a link between your training environment and local computer. Anything created inside the workspace in the training environment will also be created in the directory on your machine, and vice versa. This allows you to easily open and edit files in the workspace in your preferred editor.

---

## Contact

This project is open source, any feedback is welcome in the form of GitHub issues.

For any questions regarding a full training workshop on Ansible for your company or team, contact Verifa at [verifa.io](https://verifa.io/contact/)
