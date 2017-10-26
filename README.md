# Outils formels de modelisation @ University of Geneva

Ce document contient des informations importantes concernant ce cours.
Les règles concernant le fonctionnement du cours, des exercices et des travaux notés sont indiqués.

## Important Information and Links

Page sur GitHub
Les cours ont lieux le mardi de 10:15 - 12:00
Les exercises le vendredi  12:15 - 14:00

## Work environment

This course requires the following environment:

* GitHub:
  A source code hosting platform that we will for the exercises and homework.
  Create an account, and do not forget to fill your profile with your full name and your University email address.
  Ask GitHub for a Student Pack to obtain free private repositories.
* MacOS High Sierra or Ubuntu 16.04 LTS 64bits, 
  in a virtual machine, using for instance VirtualBox, or directly with a dual boot.

You are free to choose another operating system,
but note that if you do so,
**you won't receive support from the course's assistant for any system-related issues**.

Watch the course page to get notifications about the course.

You'll have to fork your this repository to submit your homeworks.
Proceed as follows:

1. Click the button **Fork** at the top of the repository homepage on GitHub.
   This will create a copy (a fork) of your repository on your own account.
2. Clone **your own** repository you just forked on your machine:
   ```bash
   git clone git@github.com:<your-username>/outils-formels-modelisation.git
   ```
3. Notify the course's assistant by posting your username on the issue #4.

**NOTE**:
Because GitHub does not support private forks (cloning this repository and recreating privately on your account is not a fork),
we won't use private repositories for this course.

### Setup your SSH keys on GitHub

To clone, pull and ultimately push updates to your repository, you'll need GitHub to know your identity.
The best way to do that is to
[setup SSH keys](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/).

Alternatively, you can clone over HTTPS and use your credentials (username/password)
every time you communicate with the origin.

### Merge updates from the upstream

I'll be posting updates to this repository for new homeworks or fixed on existing files.
To merge those updates, run the following command in your local repository (the one you cloned from your fork):

```bash
git pull https://github.com/cui-unige/outils-formels-modelisation.git master
```

## Important note:

You must do your homework in your private fork of the course repository.
You must fill your full name in your GitHub profile.
If for any reason you have trouble with the deadline, contact your teacher as soon as possible.
We must have access to your source code, that must be private.
Your source code (and tests) must pass all checks of ... without warnings or errors.
Your tests must cover at least 80% of the source code, excluding test files.

## Getting started with Swift:

https://swift.org/getting-started/

> Officially supported OS versions are macOS 10.12 (Sierra) and Ubuntu 16.10.
> You are highly encouraged to use either of those versions.

* Tutorial on Swift: https://kyouko-taiga.github.io/swift-thoughts/tutorial/
* Petri net simulator: https://github.com/kyouko-taiga/PetriKit
