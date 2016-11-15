Oric-SMT
-------------
An experiment on combining tests and software verification with SMT 
solvers for the case of the program searching origin of replication in 
bacterial genomes. Here I use SPARK subset of ADA for verification and
verification summary is given in gnatprove.out file. Other files:

 - **oric.ads/ oric.adb** : code partially verified using only SMT solvers
 - **oric_unsafe.ads/ oric_unsafe.adb** :  code left unverified
 - **runner.adb** : some simple unit tests

I'm going to verify more properties in future and expand this code to a fully
working program to be used in search of origin of replication for "real world
cases". Most functional blocks are already present. All the code is provided under GPLv2 license.
