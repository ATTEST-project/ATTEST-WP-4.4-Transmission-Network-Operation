# ATTEST-WP-4.4-Transmission-Network-Operation
T4.4-Tool for ancillary services procurement in day-ahead operation planning of the transmission network 

To successfully run the tool the following Julia Packages:
```
using JuMP,OdsIO,MathOptInterface,Dates,LinearAlgebra, JLD2
```
This code is capable of runnig the following problems:

Contingency Filtering

AC-optimal power flow  

AC-security constrained optimal power flow

Tractable Stochastic Multi-period AC-SCOPF (S-MP-SCOPF)

Security Assessment 

Power Flow 

which will be activated by inserting 1 to 6 in REPL, respectively. Among these, tractable S-MP-SCOPF is the main developed tool in ATTEST.  

**S-MP-SCOPF** 

The input files are the Croatian, UK, Portuguese, and Nordic32 networks in ods format. Each network supports the code with two input files, e.g. UK.ods and UK_PROF.ods. These two files include the topological data, load profiles for both a Summer and a Winter typical day, contingencies, and the flexibility allocations and capacities for each network. The flexibility activation, year, and Summer or Winter simulations are the options that a user can assign. 

The output files will be generated in xlsx format for both Normal and Post-contingency operation states under the name, e.g. UK_SU_wof_Normal.xlsx and UK_SU_wof_Contin.xlsx which means the result for the UK network for a Summer day and without flexibility. The output includes the optimal set points of the conventional generators, electric vehicles (EV), energy storage systems (ESS) for each operation state. In addition, the corresponding costs are included. 
