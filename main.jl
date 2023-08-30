using JuMP,OdsIO,MathOptInterface,Dates,LinearAlgebra, JLD2
# using Ipopt
# using BenchmarkTools
# using CPLEX
# using SCIP       # It is not useful for our purpose. Mianly deals with the feasibility problem.
# using AmplNLWriter
# using Cbc

#-------------------Accessing current folder directory--------------------------
println(pwd());
cd(dirname(@__FILE__))
println(pwd());

# files = cd(readdir, string(pwd(),"\\Network_Data"))
#--------------------Read Data from the Excel file------------------------------



include("data_preparation\\data_set_selection.jl")

# filename = "input_data/case5_bus_new.ods"
filename_scenario= "input_data/scenario_gen.ods"
# filename_scenario= "scenario_gen.ods"
# filename = "case_34_baran_modf.ods"
include("data_preparation/data_types.jl")      # Reading the structure of network related fields

include("data_preparation/data_types_contingencies.jl")

include("data_preparation/data_reader.jl")     # Function setting the data corresponding to each network quantity

include("data_preparation/interface_excel.jl") # Program saving all the inforamtion related to each entity of a power system


#-----------functions---------------------
include("functions/network_topology_functions.jl")

include("data_preparation/contin_scen_arrays.jl")

include("functions/function_activation.jl")

include("repos/flexibility_activation.jl")

include("functions/AC_SCOPF_functions.jl")

include("functions/PF_functions_common.jl")
include("functions/PF_functions_n.jl")
include("functions/PF_functions_c.jl")

include("functions/tractable_SCOPF_functions.jl")




#----------------------- Formatting of Network Data ----------------------------


println("")
show("Initial functions are compiled. ")
println("")

wf=[]
if flo==1
    wf="wf"
elseif flo==0
    wf="wof"
end

if problem==1
    include("repos\\contin_filtering_new.jl")
    show("Set of contingencies are added to $(nam)_PROF input file.")
elseif    problem==2
    include("repos\\AC_OPF.jl")
    include("repos\\OPF_out.jl")
elseif problem==3
    include("repos\\AC_SC_OPF.jl")
    include("repos\\SC_OPF_out.jl")
elseif problem==4
    include("repos\\DC_SCOPF.jl")
    # if empty_contin==0
    if termination_status(model_name)==MathOptInterface.OPTIMAL || termination_status(model_name)==MathOptInterface.LOCALLY_SOLVED  || termination_status(model_name)==MathOptInterface.ALMOST_OPTIMAL || termination_status(model_name)==MathOptInterface.ALMOST_LOCALLY_SOLVED
    include("repos\\SC_OPF_out.jl")
    include("repos\\Severity.jl")
    include("repos\\output_T4_5.jl")
    end
    # end
elseif problem==5
    # include("repos\\Security_Assessment_tool.jl")
    include("repos\\remove_harmless_combinations_SA_OPF.jl")
elseif problem==6
    include("functions\\Power_Flow_tool.jl")
end
