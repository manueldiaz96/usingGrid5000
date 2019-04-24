# Guide to use Grid5000 (Chroma Team @ Inria)
Grid'5000 is a large-scale and versatile testbed for experiment-driven research in all areas of computer science, with a focus on parallel and distributed computing including Cloud, HPC and Big Data. [Grid5000's website](https://www.grid5000.fr/w/Grid5000:Home)

This guide is mainly focused on how to use Grid5000 as an alternative to processing when hardware like GPUs are not available for local use.

## First step: [Get an account](https://www.grid5000.fr/w/Grid5000:Get_an_account).
There are two main types of accounts:
 - **Academics from France**: Those currently working on any research project in France or Academics abroad working on a collaboration with academics in France (_The former need to ask to their french collaborators for details_).
 - **Open Access Program**: People who are not on a collaboration can request a lower priority account. Private companies interested need to contact Gird5000's executive committee members.

**For this part you will need to give your ssh public key. If you have not generated one, [follow this tutorial to generate one](https://www.grid5000.fr/w/SSH#Overview)**

## Second step: Choose a cluster to work in
[This is a list of all the hardware available on Grid5000](https://www.grid5000.fr/w/Hardware). Check the list to know which cluster better suits your needs. At the moment of creation of this guide, these were the clusters with CUDA capable GPUs:

| Site          | Cluster        | Available GPUs                                  |
|:-------------:|:--------------:|:-----------------------------------------------:|
| Lille         | chifflet       | Nvidia GTX 1080Ti x 2                           |
| Lille         | chifflot       | Nvidia Tesla P100 x 2 and Nvidia Tesla V100 x 2 |
| Lyon          | orion          | Nvidia Tesla M2075                              |
| Nancy         | graphique      | Nvidia Titan Black x 2 and Nvidia GTX 980 x 2   |
| Nancy         | grele          | Nvidia GTX 1080Ti x 2                           |
| Nancy         | grimani        | Nvidia Tesla K40M                               |

Once you have chosen a cluster, you can log in into your account via: `ssh username@access.grid5000.fr`, to then ssh to the site that has the cluster you want to work in, e.g. `ssh nancy / ssh lille / ssh lyon`. Now you should be able to access your home directory on any of the Grid5000's clusters.

## Third step: Set up your work environment
### Install Miniconda
The steps listed here are based on [this tutorial](https://www.grid5000.fr/w/User:Ibada/Tuto_Deep_Learning#with_anaconda) by the user Ibada. This guide only covers the setting up process with Anaconda, Miniconda specifically since is lighter. All commands are executed from the user's home directory.

First, download Miniconda depending on the version of Python you will be working with. If you are working with Python 2.7, change the version of Miniconda to 2 instead of 3.

For Python 3.7:
```
user@site:~$ wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
```
Then, run it:
```bash
user@site:~$ bash Miniconda3-latest-Linux-x86_64.sh
```
Here, the instalation guide will prompt you to choose the path where Miniconda will be installed. Also, it will prompt you to choose if the conda environment starts with bash (default is no).

Finally, just copy the `.bashrc` script available on this repository and change **user** for your username on lines 112, 116, 117, 120. It contains many useful features to personalize your bash experience, **but more importantly** if you chose the default option for conda to be disabled, sourcing this script allows you to activate the conda environment.

```bash
user@site:~$ source .bashrc
(base) user@site:~$ #Environment now 
```
### Create the virtual environment and Install the needed libraries
With Miniconda set up, you can now create environments for your projects via:
```
conda create --name env
```
And install conda supported libraries and packages via [Anaconda Cloud](https://anaconda.org/anaconda/), [Conda Forge](https://anaconda.org/conda-forge/) or any other channel you want.

## Fourth step: Ask for compute time on the GPU clusters
You can check [here](https://www.grid5000.fr/w/Status) the status of each of the clusters' availability, to see if your desired hardware is busy or not.

[These bash scripts](https://github.com/manueldiaz96/usingGrid5000/tree/master/ask_for_job_scripts) facilitate the process of asking for jobs. Both are mainly using on the `oarsub` commands and using the **_default_** queue, check the [hardware wiki page](https://www.grid5000.fr/w/Hardware) to which queue the GPUs you are going to use are in:
 - `ask_for_job_fixed_time.sh` has a fixed job time, can be used to quickly test if the environment recognizes the cluster's GPUs
 - `ask_for_job_input_time.sh` lets you input time as an argument in the format _hh:mm:ss_. Can be used e.g. when you have an estimated train time for a network. 
 
For example, using the `ask_for_job_input_time.sh`:
```bash
user@flille:~$ bash ask_for_job_scripts/ask_for_job2.sh 00:05:00
 Remember to source bashrc!
 Remember to activate the conda env!
[ADMISSION RULE] Modify resource description with type constraints
[ADMISSION_RULE] Resources properties : \{'property' => 'type = \'default\'','resources' => [{'resource' => 'host','value' => '1}]}
[ADMISSION RULE] Job properties : (GPU <> 'NO') AND maintenance = 'NO'
Generate a job key...
OAR_JOB_ID=1681786
Interactive mode: waiting...
Starting...

Connect to OAR job 1681786 via the node chifflet-6.lille.grid5000.fr
user@chifflet-6:~$ source .bashrc 
(base) user@chifflet-6:~$ conda activate pytorch_env
(pytorch_env) user@chifflet-6:~$ python pytorch_probe_gpus.py
GeForce GTX 1080 Ti detected on device 0
GeForce GTX 1080 Ti detected on device 1
(pytorch_env) user@chifflet-6:~$ #GPUs detected!
```
Once you are in a job, you can use the available hardware on that specific cluster for your computations.

## Other useful commands
To transfer a file from the machines to your local PC via secure copy:
```bash
user@localPC:~$ scp user@access.grid5000.fr:site/path_from_home/file.py /home/user/directory/file.py #for single files
user@localPC:~$ scp -r user@access.grid5000.fr:site/path_from_home/directory /home/user/directory/ #for directories
```
To transfer a file from your PC to a cluster via secure copy:
```bash
user@localPC:~$ scp /home/user/directory/file.py user@access.grid5000.fr:site/path_from_home/file.py #for single files
user@localPC:~$ scp -r /home/user/directory/ user@access.grid5000.fr:site/path_from_home/directory #for directories
```
Commands to check or delete  jobs:
```bash
user@site:~$ oarstat -u #check if you have any jobs running on this site and the state of them
user@site:~$ oardel JOB_ID #delete any job you no longer need by giving the JOB_ID number
```

For more in-depth usage of Grid5000 for Deep Learning, [Check Ibada's tutorial](https://www.grid5000.fr/w/User:Ibada/Tuto_Deep_Learning)
