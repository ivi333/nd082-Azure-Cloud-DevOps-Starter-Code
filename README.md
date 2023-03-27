# Overview

![image](https://user-images.githubusercontent.com/3152635/224437421-57377ae1-bb39-4d14-922e-27364ebe4432.png)


## Project Plan
<TODO: Project Plan

* A link to a Trello board for the project
* A link to a spreadsheet that includes the original and final project plan>

## Instructions

<TODO:  
* Architectural Diagram (Shows how key parts of the system work)>

Instructions for running the Python project.  

* Clone the project and create the App Service in Azure:
```
az webapp up -n udacity-gomezlivan  -g MyRG -l francecentral --sku F1 --runtime "PYTHON:3.7
```

* Project running on Azure App Service
![image](https://user-images.githubusercontent.com/3152635/224437632-544ccb51-fe28-40c5-90a8-d350811aec25.png)

* Project cloned into Azure Cloud Shell
```
(.myrepo) gomezl_ivan [ ~/azure-udacity-lab ]$ cat .git/config 
[core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
[remote "origin"]
        url = git@github.com:ivi333/azure-udacity-lab.git
        fetch = +refs/heads/*:refs/remotes/origin/*
[branch "main"]
        remote = origin
        merge = refs/heads/main
[pull]
        rebase = true
(.myrepo) gomezl_ivan [ ~/azure-udacity-lab ]$ 
```

* Passing tests that are displayed after running the `make all` command from the `Makefile`
The applications doesn't include tests, so all tests are passed

* Output of a test run
No tests found in the application

* Successful deploy of the project in Azure Pipelines.  [Note the official documentation should be referred to and double checked as you setup CI/CD](https://docs.microsoft.com/en-us/azure/devops/pipelines/ecosystems/python-webapp?view=azure-devops).

* Running Azure App Service from Azure Pipelines automatic deployment
![image](https://user-images.githubusercontent.com/3152635/224442304-54a47480-4af5-4689-a508-6185e7e2e05c.png)

* Successful prediction from deployed flask app in Azure Cloud Shell.  [Use this file as a template for the deployed prediction](https://github.com/udacity/nd082-Azure-Cloud-DevOps-Starter-Code/blob/master/C2-AgileDevelopmentwithAzure/project/starter_files/flask-sklearn/make_predict_azure_app.sh).
The output should look similar to this:

```bash
udacity@Azure:~$ ./make_predict_azure_app.sh
Port: 443
{"prediction":[20.35373177134412]}
```

* Output of streamed log files from deployed application
![image](https://user-images.githubusercontent.com/3152635/224441869-87d04e23-55b4-4ecb-b472-a431177dba66.png)

> 

## Enhancements

The project could be improved deploying the App Service using Docker or Kubernetes with the following scripts provided:
- run_docker.sh
- run_kubernetes.sh

## Demo 

<TODO: Add link Screencast on YouTube>


