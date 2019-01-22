# Taskcluster Integration for Web Extensions

This is a proof-of-concept to show that a Firefox [web extension](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions) (or [web extension experiment](https://firefox-source-docs.mozilla.org/toolkit/components/extensions/webextensions/index.html)) can be tested using Mozilla CI--principally on the [Try server](https://firefox-source-docs.mozilla.org/tools/try/index.html) via [Taskcluster](https://docs.taskcluster.net/docs/tutorial/what-is-tc). For more, see [Motivation](#motivation) in the Appendix.



## What this does now

This project demonstrates the following capabilities using Taskcluster:
* Run extension-specific tests in Node
* Upload extension's XPI as a build artifact
* Run regression tests on the Try server with the extension installed

This is largely done through the [Taskcluster config file](.taskcluster.yml) in the project's root directory.



## What this is ultimately going to do

In addition to the capabilities listed above, ultimately, this project will also:
* Provide a baseline Taskcluster config that developers can drop into their existing GitHub repositories
* Allow developers to run custom Mozilla tests on the Try server (See [Issue #8](https://github.com/biancadanforth/taskcluster-integration-poc/issues/8))
* Suggest the minimum set of Mozilla tests to run and when (See [Issue #14](https://github.com/biancadanforth/taskcluster-integration-poc/issues/14))



## Developing


### Prerequisites

1. Have Firefox installed.
2. Be a collaborator for this repo. This process will be generalized eventually (See [Issue #16](https://github.com/biancadanforth/taskcluster-integration-poc/issues/16)).


### Installing

Clone the repo
```
git clone https://github.com/biancadanforth/taskcluster-integration-poc.git
```

Change directories into the repo
```
cd taskcluster-integration-poc
```

Install dependencies
```
npm install
```

Build the extension
```
npm run build
```

Run the extension
```
npm start
```
Note: Currently the extension is a stub that has no UI and simply injects a content script on every `http://` and `https://` page.



### Testing


#### Local testing

Run linting
```
npm run lint
```


#### Testing on the Try server

To run existing Mozilla tests in Firefox on the Try server, open a PR. Taskcluster will start up a task to do this automatically.

The task's status can be viewed in the PR in GitHub. Task details, logs and build artifacts can be found in the [Taskcluster dashboard](#the-taskcluster-dashboard).

The link to the Treeherder page where the Mozilla test results are displayed can be found in the [task logs](#viewing-logs).



## Appendix


### Motivation

Running experiments in Firefox is an important way for Mozilla to innovate. Some experiments take the form of a web extension. Often, these extension-based experiments are developed and deployed off-train (i.e. outside of Firefox's normal development and release process) which, without careful testing and review, can pose significant risks.

As one of many ways to mitigate such risks, it would be beneficial to regularly perform regression tests in Firefox with the extension installed. To date, this process has been labor-intensive, requiring a lot of knowledge of Firefox and its build system and other tooling. If those steps can be simplified or even automated, then these tests can be much more easily and much more frequently performed, and Firefox engineering will have the data it needs to make a go/no-go decision on whether the extension is safe to ship to users.


### The Taskcluster Dashboard

The Taskcluster dashboard contains information specific to the task that was initiated.


#### How to access the dashboard

In any PR, click the status icon next to a particular commit (this icon could be a green check mark, a red X or a yellow dot depending on if the job was successful, unsuccessful or is in progress, respectively), and then click the "Details" link:

![Taskcluster status link](/images/taskcluster_gh_ui.png)

Alternatively, click the "Details" link in the Taskcluster status UI at the bottom of the PR; this will link the the dashboard for the most recent commit.

Once in the dashboard, in the Task Group tab, click the link under the Name column. This will open the Task Details tab. 


#### Viewing logs

The logs show the output of the shell in which the task is running.

Once in the Task Details tab, select the Run Logs tab and choose a log to view from the dropdown menu.


#### Downloading artifacts

Artifacts are downloadable files generated within the task execution (e.g. task logs or build files).

Once in the Task Details tab, select the Run Artifacts tab. This tab displays a list of all artifacts created by this task.



### Tasks


#### Configuring Tasks

This is done in the [Taskcluster config file](.taskcluster.yml); there we define what steps to perform in a task and when the task should be triggered.

This repo is configured to spin up the same task on opening, re-opening and synchronizing pull requests as well as merging a feature branch into the master branch.


#### Retriggering Tasks

This will duplicate the task and create it under a different `taskId`.

In the Taskcluster dashboard, select Retrigger Task from the Actions dropdown menu.

Note: By default, most Taskcluster users will not have the scopes (i.e. permissions) to rerun a task, which (unlike a retrigger) causes a new run of the task to be created with the same `taskId`.


#### Cancelling Tasks

Only Taskcluster team members can cancel jobs. However, it is possible to cancel a Try run triggered by Taskcluster through [Treeherder](https://wiki.mozilla.org/EngineeringProductivity/Projects/Treeherder), the Try server dashboard.

The link to the Treeherder dashboard can be found in the [task logs](#viewing-logs).



### Additional resources

* [Taskcluster Documentation](https://docs.taskcluster.net/docs)
* [Example Taskcluster config file](https://github.com/taskcluster/taskcluster-github/blob/master/.taskcluster.yml)



## License

This project is licensed under the MPL v2.0. See [`LICENSE`](LICENSE) for details.
